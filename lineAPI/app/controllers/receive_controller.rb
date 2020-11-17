class ReceiveController < ApplicationController

  require 'net/http'
  require 'uri'

  def create
    
    # 署名の検証
    render status: :ok unless valid_signature

    params[:events].each do |event|
      case event[:type]
      when "follow","join" then
        receive_create_user event
      when "unfollow","leave"
        receive_delete_user event
      end    
    end
  end

  private
    
    def receive_create_user(param_event)
      send_schedule_api("users", :post, form_data: params_create_user(param_event))
    end

    def receive_delete_user(param_event)
      user = params_create_user(param_event)
      send_schedule_api("users/#{user[:line_id]}", :delete)
    end

    def send_schedule_api(path, method, **args)
      url = URI.parse(Constants::SCHEDULE_API_URI + path)
      case method
      when :get then
        req = Net::HTTP::Get.new(url.path)
      when :post then
        req = Net::HTTP::Post.new(url.path)
        req.content_type = 'application/json'
        req.body = args[:form_data].to_json
      when :delete then
        req = Net::HTTP::Delete.new(url.path)
      end
      logger.debug("start #{method} to schedule_api\n" + req.inspect)
      res = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }
      logger.debug("end #{method} to schedule_api\n" + res.inspect)
      res
    end

    def params_create_user(params_event)

      user = {user_type: params_event[:source][:type] }
      if user[:user_type] == "room"
        user[:line_id] = params_event[:source][:roomId]
      elsif user[:user_type] == "group"
        user[:line_id] = params_event[:source][:groupId]
      elsif user[:user_type] == "user"
        user[:line_id] = params_event[:source][:userId]
      end
      user
    end

    def valid_signature
      http_request_body = request.raw_post # Request body string
      hash = OpenSSL::HMAC::digest(OpenSSL::Digest::SHA256.new, 
              Constants::LINE_CHANNEL_SECRET, http_request_body)
      signature = Base64.strict_encode64(hash)
      signature == request.headers['X-Line-Signature']
    end

    
end

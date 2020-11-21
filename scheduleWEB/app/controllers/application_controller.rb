class ApplicationController < ActionController::Base

  include SessionsHelper

  private
    
    def logged_in_user
      unless logged_in?
        redirect_to login_url
      end
    end

    def not_logged_in_user
      if logged_in?
        redirect_to users_url
      end
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

end

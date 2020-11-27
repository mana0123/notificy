class ReceiveController < ApplicationController

  def create
    
    # destinationの検証
#     unless valid_destination
#      logger.warn "destination is invalid:"
#      head :bad_request
#      return
#    end

    # 署名の検証
    unless valid_signature
      logger.warn "signature is invalid:"
      head :bad_request
      return
    end

    params[:events].each do |event|
      case event[:type]
      when "follow","join" then
        receive_create_user event
      when "unfollow","leave"
        receive_delete_user event
      when "message"
        receive_message event
      end    
    end
    head :ok
  end

  private
    
    def receive_create_user(param_event)
      send_api(:schedule, "users", :post, 
               content_type: 'application/json', 
               form_data: params_create_user(param_event))
    end

    def receive_delete_user(param_event)
      user = params_create_user(param_event)
      send_api(:schedule, "users/#{user[:line_id]}", :delete)
    end

    def receive_message(param_event)
      if param_event[:message][:type] == "text"
        case param_event[:message][:text]
        when "登録"
          receive_message_touroku(param_event)
        end
      end
    end

    def receive_message_touroku(param_event)
      user = params_create_user(param_event)
      res = send_api(:web_ap, "api/onetime_session", :post,
                     content_type: 'application/json', 
                     form_data: { name: user[:line_id] })
      res_body = JSON.parse(res.body)
      return if res_body["access_url"].nil?

      text = "登録URL:\n#{res_body["access_url"]} \n※有効期限はURL発行後30分以内です。\n※本URLは1回のみ有効です。"
      reply_form = { replyToken: param_event["replyToken"], 
                     messages: [ 
                      { type: "text", text: text } ] }
      send_api(:line, 'v2/bot/message/push', :post, content_type: 'application/json', form_data: reply_form)
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

    def valid_destination
      params[:destination] == Constants::LINE_USER_ID
    end
    
end

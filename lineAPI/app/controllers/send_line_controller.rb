class SendLineController < ApplicationController
  def messages
    return head 400 unless form_data = post_param
    req = send_api(:line, 'v2/bot/message/push', :post, content_type: 'application/json', form_data: form_data)    
  end

  private
    def post_param
      return false if params[:to].nil? || params[:messages].nil?
      return false unless params[:messages].is_a?(Array)

      hash = params.permit(:to).to_hash
      hash["messages"] = params.require(:messages).map do |message|
        message.permit([:type, :text]).to_hash
      end
      hash
    end
end

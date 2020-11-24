class SendLineController < ApplicationController
  def messages
    form_data = post_param
    req = send_api(:line, 'v2/bot/message/push', :post, content_type: 'application/json', form_data: form_data)    
  end

  private
    def post_param
      head 400; return if params[:to].nil? || params[:messages].nil?
      head 400; return unless params[:messages].is_a?(Array)

      hash = params.permit(:to).to_hash
      hash["messages"] = params.require(:messages).map do |message|
        message.permit([:type, :text]).to_hash
      end
      hash
    end
end

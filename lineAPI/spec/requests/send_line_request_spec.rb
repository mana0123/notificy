require 'rails_helper'

RSpec.describe "SendLines", type: :request do
  describe "POST /send_line/messages" do
    describe "normal test" do
      it "post send messages" do
        json_body =
          '{ "to": "Ufa595128e0baa511c3ee236f87e4b2fa",
           "messages": [ { "type": "text", "text": "testest" } ] }'
        request_header = {'CONTENT_TYPE': 'application/json'}
        post "/send_line/messages", params: json_body, headers: request_header
      end
    end
  end

end

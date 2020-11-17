require 'rails_helper'

RSpec.describe "Receives", type: :request do
  describe "POST /receives" do
    it "post join chat room" do
      json_body =
      '{ "destination": "Ufa595128e0baa511c3ee236f87e4b2fa",
         "events": [
          {
           "replyToken": "nHuyWiB7yP5Zw52FIkcQobQuGDXCTA",
           "type": "join",
           "mode": "active",
           "timestamp": 1462629479859,
           "source": {
            "type": "room",
            "roomId": "Ra8dbf4673c",
            "userId": "U4af4980629"
           }
         }
        ]}'
      request_header = { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' , 'X-Line-Signature' => 'A47Up0zmjssG8tyjs+WrgoX/Ct3azCWChzAyLqRwc/c='}

      post "/receive", params: json_body, headers: request_header

      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
    end

    it "post leave chat room" do
      json_body =
      '{ "destination": "Ufa595128e0baa511c3ee236f87e4b2fa",
         "events": [
          {
           "replyToken": "nHuyWiB7yP5Zw52FIkcQobQuGDXCTA",
           "type": "leave",
           "mode": "active",
           "timestamp": 1462629479859,
           "source": {
            "type": "room",
            "roomId": "Ra8dbf4673c",
            "userId": "U4af4980629"
           }
         }
        ]}'
      request_header = { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' , 'X-Line-Signature' => 'e1SqBUaccpv4geRrpFRo8g9c0/tFg4+w4TTG/gm0NUM='}

      post "/receive", params: json_body, headers: request_header

      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
    end

  end
end

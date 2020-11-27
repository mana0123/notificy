require 'rails_helper'

RSpec.describe "Receives", type: :request do
  describe "POST /receives" do
    describe "normal test" do
      it "post join chat room" do
        json_body =
        '{ "destination": "Ufa595128e0baa511c3ee236f87e4b2fa",
             "events": [ {
             "replyToken": "nHuyWiB7yP5Zw52FIkcQobQuGDXCTA",
             "type": "join", "mode": "active", "timestamp": 1462629479859,
             "source": { "type": "room", "roomId": "Ra8dbf4673c",
             "userId": "U4af4980629" } } ]}'
        signature = create_signature(json_body)
        request_header = set_header(signature)

        post "/receive", params: json_body, headers: request_header

        expect(response.status).to eq(200)
      end

      it "post leave chat room" do
        json_body =
        '{ "destination": "Ufa595128e0baa511c3ee236f87e4b2fa",
           "events": [ {
             "replyToken": "nHuyWiB7yP5Zw52FIkcQobQuGDXCTA",
             "type": "leave", "mode": "active", "timestamp": 1462629479859,
             "source": { "type": "room", "roomId": "Ra8dbf4673c",
             "userId": "U4af4980629"} } ]}'
        signature = create_signature(json_body)
        request_header = set_header(signature)

        post "/receive", params: json_body, headers: request_header

        expect(response.status).to eq(200)
      end

      it "event empty" do
        # ライン側から疎通確認で送られることがある
        json_body =
        '{ "destination": "Ufa595128e0baa511c3ee236f87e4b2fa",
           "events": [] }'
        signature = create_signature(json_body)
        request_header = set_header(signature)

        post "/receive", params: json_body, headers: request_header

        expect(response.status).to eq(200)
      end

      it "post messages tourokou" do
        json_body =
        '{ "destination": "Ufa595128e0baa511c3ee236f87e4b2fa",
           "events": [ {
             "replyToken": "nHuyWiB7yP5Zw52FIkcQobQuGDXCTA",
             "type": "message", "mode": "active", "timestamp": 1462629479859,
             "source": { "type": "room", "roomId": "Ra8dbf4673c",
               "userId": "U4af4980629" } ,
             "message": { "id": "325708", "type": "text",
               "text": "登録" }
           } ] }'
        signature = create_signature(json_body)
        request_header = set_header(signature)

        post "/receive", params: json_body, headers: request_header

        expect(response.status).to eq(200)
      end
    end

    describe "abnormal test" do
      it "unexpect event" do
        json_body =
        '{ "destination": "Ufa595128e0baa511c3ee236f87e4b2fa",
           "events": [ {
             "replyToken": "nHuyWiB7yP5Zw52FIkcQobQuGDXCTA",
             "type": "test", "mode": "active", "timestamp": 1462629479859
             } ] }'
        signature = create_signature(json_body)
        request_header = set_header(signature)

        post "/receive", params: json_body, headers: request_header
        
        expect(response.status).to eq(200)
      end

      it "schedule api has error" do
        
        # 存在しないユーザで削除してみる
        json_body =
        '{ "destination": "Ufa595128e0baa511c3ee236f87e4b2fa",
           "events": [ {
             "replyToken": "nHuyWiB7yP5Zw52FIkcQobQuGDXCTA",
             "type": "leave", "mode": "active", "timestamp": 1462629479859,
             "source": { "type": "room", "roomId": "Ra8dbf4673c",
             "userId": "U4af4980629" } } ]}'

        signature = create_signature(json_body)             
        request_header = set_header(signature)         

        post "/receive", params: json_body, headers: request_header

        expect(response.status).to eq(200)
      end
      
      it "invalid signature" do
        json_body =
        '{ "destination": "Ufa595128e0baa511c3ee236f87e4b2fa",
           "events": [ {
             "replyToken": "nHuyWiB7yP5Zw52FIkcQobQuGDXCTA",
             "type": "join", "mode": "active", "timestamp": 1462629479859,
             "source": { "type": "room", "roomId": "Ra8dbf4673c",
             "userId": "U4af4980629" } } ]}'
        
        request_header = set_header("test")

        post "/receive", params: json_body, headers: request_header

        expect(response.status).to eq(400)
      end

      it "invalid destination" do
        json_body =
        '{ "destination": "Ufa595128e0baa511c3ee236f87e4b2faAAA",
           "events": [ {
             "replyToken": "nHuyWiB7yP5Zw52FIkcQobQuGDXCTA",
             "type": "join", "mode": "active", "timestamp": 1462629479859,
             "source": { "type": "room", "roomId": "Ra8dbf4673c",
             "userId": "U4af4980629" } } ]}'

        signature = create_signature(json_body)
        request_header = set_header(signature)

        post "/receive", params: json_body, headers: request_header

        expect(response.status).to eq(400)
      end
    end
  end

  def create_signature(body)
    signature = Base64.strict_encode64(
                OpenSSL::HMAC::digest(OpenSSL::Digest::SHA256.new,
                Constants::LINE_CHANNEL_SECRET, body))
  end

  def set_header(signature)
    request_header = {
          'CONTENT_TYPE' => 'application/json',
          'ACCEPT' => 'application/json' ,
          'X-Line-Signature' => signature }
  end
end

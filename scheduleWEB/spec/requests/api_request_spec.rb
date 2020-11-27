require 'rails_helper'
include ConnApi

RSpec.describe "Apis", type: :request do
  describe 'POST /api/onetime_session' do

    before :all do
      # scheduleAPI側に存在するユーザを取得
      res = send_schedule_api("users", :get)
      @users = JSON.parse(res.body)["users"]
    end

    describe 'normal test' do
      it 'create access token new user' do
        user = @users[0]
        valid_params = { name: user["line_id"] }
        expect {
          post '/api/onetime_session', params: valid_params
        }.to change(User, :count).by(+1)
        json = JSON.parse(response.body)

        expect(response.status).to eq(200)
        expect(json['access_url']).not_to eq(nil)
      end

      it 'create access token exist user(fist token)' do
        user = @users[0]
        user_old = User.create(name: user["line_id"], user_type: 2, status: 1)
        valid_params = { name: user_old.name }
        expect {
          post '/api/onetime_session', params: valid_params
        }.to change(User, :count).by(0)
        json = JSON.parse(response.body)
        user_new = User.find_by(name: user["line_id"])
        expect(response.status).to eq(200)
        expect(json['access_url']).not_to eq(nil)
        # digestが更新されているかの確認
        expect(user_new.access_digest).not_to eq(user_old.access_digest)
      end
    end
  end
end

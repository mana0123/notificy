require 'rails_helper'

RSpec.describe "Sessions", type: :request do

  describe "GET /new" do
    it "returns http success" do
      get "/sessions/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /login/line_user" do
    describe "normal test" do
      it "not expired user" do
        # 対象ユーザの作成
        user = User.create(name: "test", user_type: 2, status: 1)
        user.update_attributes(access_digest: User.digest("token"), access_at: Time.zone.now)
        expect(user.access_digest).not_to eq(nil)
        expect(user.access_at).not_to eq(nil)

        get "/login/line_user?id=#{user.id}&token=token"

        user = User.find_by(id: user.id)
        expect(user.access_digest).to eq(nil)
        expect(user.access_at).to eq(nil)

        expect(response).to redirect_to("/users/#{user.name}")
        expect(session[:user_id]).to eq(user.id)

      end
    end

  end

end

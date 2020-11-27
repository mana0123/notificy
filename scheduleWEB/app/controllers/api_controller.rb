class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token

  def onetime_session

    # ユーザの存在(API側)チェック
    res = send_schedule_api("users/#{params[:name]}", :get)
    res_data = JSON.parse(res.body)
    if res_data["user"].nil?
      render json: {messages: "\[#{params[:name]}\] is not found."}
      return
    end
    user = User.find_by(name: params[:name])
    if user && user.user_type == 2
      user.create_new_access_token
    elsif user.nil?
      user = User.create(name: params[:name], user_type: 2, status: 1)
      user.create_new_access_token
    else
      render json: {messages: "\[#{params[:name]}\] is not line user."}
      return
    end
    render json: { access_url: login_line_user_url(id: user.id, token: user.access_token, protocol: 'https') }

  end
end

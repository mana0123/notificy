class UsersController < ApplicationController

  require 'net/http'
  require 'uri'

  def index
    res = send_schedule_api("users", :get)
    res_data = JSON.parse(res.body)
    @users = res_data["users"]
  end

  def create

  end

  def show
    res_user = send_schedule_api("users/#{params[:id]}", :get)  
    res_user_data = JSON.parse(res_user.body)
    @user = res_user_data["user"]

    res_schedule_items = send_schedule_api("users/#{params[:id]}/schedule_items", :get)
    res_schedule_items_data = JSON.parse(res_schedule_items.body)
    @schedule_items = res_schedule_items_data["schedule_items"]

  end

  def edit

  end

  def destroy
    send_schedule_api("users/#{params[:id]}", :delete)
    redirect_to action: :index
  end

end

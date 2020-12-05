class UsersController < ApplicationController

  require 'net/http'
  require 'uri'

  before_action :logged_in_user
  before_action ->{ 
    logged_in_admin_or_current_user(params[:id]) 
  }, only: [:create, :show, :edit, :destroy]
  before_action :logged_in_admin_user, only: [:index]

  def index
    res = send_schedule_api("users", :get)
    res_data = JSON.parse(res.body)
    @users = res_data["users"]

    @admin_users = User.where( user_type: 1 )
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

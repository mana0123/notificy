class UsersController < ApplicationController

  require 'net/http'
  require 'uri'

  before_action :logged_in_user
  before_action ->{ 
    logged_in_admin_or_current_user(params[:id]) 
  }, only: [:create, :show, :edit, :destroy]
  before_action :logged_in_admin_user, only: [:index, :destroy_admin]

  def index
    res = send_schedule_api("users", :get)
    res_data = JSON.parse(res.body)
    @users = res_data["users"]

    @admin_users = User.where( user_type: 1 )
  end

  def new_admin
    @user = User.new()    
  end

  def create_admin
    User.create(post_param)
    redirect_to action: :index
  end

  def show_line
    res_user = send_schedule_api("users/#{params[:id]}", :get)  
    res_user_data = JSON.parse(res_user.body)
    @user = res_user_data["user"]

    res_schedule_items = send_schedule_api("users/#{params[:id]}/schedule_items", :get)
    res_schedule_items_data = JSON.parse(res_schedule_items.body)
    @schedule_items = res_schedule_items_data["schedule_items"]

  end

  def edit_admin
    @user = User.find_by(id: params[:id])
  end

  def update_admin
    @user = User.find_by(id: params[:id])
    @user.update(patch_param)
    logger.debug(patch_param)
    redirect_to action: :index
  end

  def edit_line
    res_user = send_schedule_api("users/#{params[:id]}", :get)
    res_user_data = JSON.parse(res_user.body)
    @user = res_user_data["user"]
  end

  def update_line
    send_schedule_api("users/#{params[:id]}", :patch, form_data: patch_param)
    redirect_to action: :index
  end

  def destroy_admin
    user = User.find_by(id: params[:id])
    user.destroy
    redirect_to action: :index
  end

  def destroy_line
    send_schedule_api("users/#{params[:id]}", :delete)
    redirect_to action: :index
  end

  private
    
    def post_param
      params.require(:user).permit(:name, :password, :password_confirmation)
            .merge(status: 1, user_type: 1)
    end

    def patch_param
      params.permit(:status)
    end

end

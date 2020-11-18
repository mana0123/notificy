class ScheduleItemsController < ApplicationController
  require 'net/http'
  require 'uri'

  before_action :logged_in_user

  def new
    @user_id = params[:id]
  end

  def create

    post_param = post_schedule_items_param

    # API側のパラメータdatesが配列である必要があるため、配列に置き換える
    post_param["dates"] = [post_param["dates"]] 

    # ScheduleAPIにPOST送信
    send_schedule_api("users/#{params[:user_id]}/schedule_items", 
                      :post, form_data: post_param)

    redirect_to controller: :users, action: :show, id: params[:user_id],
                status: :ok

  end

  def show

    @user = send_schedule_api("users/#{params[:id]}", :get).body["user"]
    @schedule_items = send_schedule_api(
        "users/#{params[:id]}/schedule_items", :get).body["schedule_items"]

  end

  def edit

  end

  def destroy

  end

  private

    def post_schedule_items_param
      params.require(:post)
            .permit(:content, dates: [:year, :month, :week, :day, :hour])

    end

end

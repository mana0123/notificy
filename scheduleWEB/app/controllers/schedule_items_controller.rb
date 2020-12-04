class ScheduleItemsController < ApplicationController
  require 'net/http'
  require 'uri'

  before_action :logged_in_user

  def new
    @user_id = params[:id]
  end

  def create

    post_param = post_schedule_items_param

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
    @schedule_item = send_schedule_api(
        "users/#{params[:user_id]}/schedule_items/#{params[:id]}", :get).body["schedule_item"]
  end

  def destroy
    send_schedule_api("users/#{params[:user_id]}/schedule_items/#{params[:id]}", :delete)
    redirect_to controller: :users, action: :show, id: params[:user_id]
  end

  private

    def post_schedule_items_param
      dates = params.permit(dates: [:full_date, :month, :week, :day, :hour, :dainan])["dates"].to_hash.map do |num,date|
        hash = {}
        if value = date["full_date"]
          # full_date（固定値）の場合
          hash[:year] = value[0..3]
          hash[:month] = value[5..6]
          hash[:day] = value[8..9]
          hash[:week] = nil
        else
          # それ以外(繰り返し)の場合
          hash[:year] = date["year"]
          hash[:month] = date["month"]
          hash[:day] = date["day"]
          hash[:hour] = date["hour"]
          if !date["week"].nil?
            # 曜日指定されている場合 
            if date["dainan"].nil?
              # 毎週指定の場合
              hash[:week] = date["week"] + "0"
            else
              # 第何曜日指定の場合
              hash[:week] = date["week"] + date["dainan"]
            end
          end
        end
        hash
      end
      { content: params[:content], dates: dates }
    end

end

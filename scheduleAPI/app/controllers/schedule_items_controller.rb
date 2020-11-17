class ScheduleItemsController < ApplicationController

  before_action :user_exist, only: [:index, :posti, :create]
  before_action :user_and_item_exist, only: [:show, :update, :destroy]

  # GET /users/{user_id}/schedule_items
  def index

    # ScheduleItemとScheduleItemDateをINNER JOINで取得
    @schedule_items = select_schedule_items_join_date(user_id: params[:user_id])

    render status: :ok

  end


  # POST /users/{user_id}/schedule_items
  def create
    logger.debug("リクエストパラメータ:" + params.inspect)
    # インスタンス変数初期化
    @schedule_item = nil
    @schedule_item_dates = []

    # 永続化
    ActiveRecord::Base.transaction do
      # schedule_itemの永続化
      logger.debug("user:" + @user.inspect)
      @schedule_item = @user.schedule_items.create!(post_schedule_item)
      # schedule_item_dateの永続化
      post_schedule_item_dates.each do |post_date| 
        @schedule_item_dates << @schedule_item.schedule_item_dates
                                             .create!(post_date)
      end
    rescue => e
      @messages = ["fail post"]
      render status: :bad_request,
             layout: 'error'
      return
    end

    render status: :ok

  end

  # GET /users/{user_id}/schedule_items/{id}
  def show
    render status: :ok
  end

  # PUT /schedule_items/:id
  def update
  end

  # DELETE /users/{user_id}/schedule_items/{id}
  def destroy
    if @schedule_item[:schedule_item].destroy
      render status: :ok
    else
      render status: :not_found
    end

  end

  private
    def post_schedule_item
      params.permit(:content)
            .merge(status: 1)
    end

    def post_schedule_item_dates
      params.require(:dates).map do |date| 
        date.permit( [:year, :month, :week, :day, :hour] )
      end
    end
    
    def user_exist
      unless @user = User.find_by(line_id: params[:user_id])
        @messages = ["id(#{params[:user_id]}) is not found"]
        render status: :not_found
        return
      end
    end

    def user_and_item_exist
      unless @schedule_item = select_schedule_items_join_date(
                id: params[:id], user_id: params[:user_id]).first
        @messages = ["id(#{params[:id]}) is not found"]
        render status: :not_found
      end
    end

    def select_schedule_items_join_date(**where)
      schedule_items = []
      ScheduleItem.eager_load(:schedule_item_dates)
                .where(where).each do |schedule_item|
        schedule_items << {schedule_item: schedule_item,
                        schedule_item_dates: schedule_item.schedule_item_dates}
      end
      schedule_items
    end
    

end

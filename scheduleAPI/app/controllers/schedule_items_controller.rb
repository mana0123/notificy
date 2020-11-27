class ScheduleItemsController < ApplicationController

  include GetRecord
  before_action :user_exist, only: [:index, :create]
  before_action :user_and_item_exist, only: [:show, :update, :destroy]
  before_action :check_param_format, only: [:create]

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
    begin
      ActiveRecord::Base.transaction do
        # schedule_itemの永続化
        logger.debug("user:" + @user.inspect)
        @schedule_item = @user.schedule_items.create(post_schedule_item)
        unless @schedule_item.errors.empty?
          raise ActiveRecord::RecordInvalid::new(@schedule_item)
        end
        # schedule_item_dateの永続化
        post_schedule_item_dates.each do |post_date| 
          schedule_item_date = @schedule_item.schedule_item_dates
                                             .create!(post_date)
          unless schedule_item_date.errors.empty?
            raise ActiveRecord::RecordInvalid::new(schedule_item_date)
          end
          @schedule_item_dates << schedule_item_date
        end
      end
    rescue => e
      @messages = [e.message]
      render "layouts/error", status: :bad_request
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
      @messages = []
      @schedule_item[:schedule_item].errors.full_messages.each { 
          |message| @messages << message }
      render "layouts/error", status: :not_found
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
        render "layouts/error", status: :not_found
        return
      end
    end

    def user_and_item_exist
      unless @schedule_item = select_schedule_items_join_date(
                id: params[:id], user_id: params[:user_id]).first
        @messages = ["id(#{params[:id]}) is not found"]
        render "layouts/error", status: :not_found
      end
    end

    def check_param_format
      # datesが配列でない場合、403を返却
      unless params[:dates].is_a?(Array)
        @messages = ["dates should be a list "]
        render "layouts/error", status: :bad_request
        return
      end
    end

end

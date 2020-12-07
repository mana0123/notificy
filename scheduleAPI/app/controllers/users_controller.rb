class UsersController < ApplicationController

before_action :user_exist, only: [:show, :update, :destroy]

  # GET /users
  def index
    @users = User.all
    render status: :ok 
  end

  # POST /users
  def create
    @user = User.new(post_user)
    if @user.save
      render status: :ok
    else
      @messages = []
      @user.errors.full_messages.each { |message| @messages << message }
      render "layouts/error", status: :bad_request
    end
  end

  # GET /users/:id
  def show
    render status: :ok 
  end

 # PUT /users/:id
  def update

    if @user.update(patch_user)
      render status: :ok, 
             json: { data: { user: @user } }
    else
      render status: :bad_request, 
             json: { data: { user: @user.errors } }
    end
  end

  # DELETE /users/:id
  def destroy
    if @user.destroy
      render status: :ok
    else
      @messages = []
      @user.errors.full_messages.each { |message| @messages << message }
      render "layouts/error", status: :bad_request
    end 
  end

  private
    def user_exist
      unless @user = User.find_by(line_id: params[:id])
        @messages = ["id(#{params[:id]}) is not found"]
        render "layouts/error", status: :not_found
        return
      end
    end

    def post_user
      params.permit(:user_type, :line_id, :status)
            .merge(status: 1)
    end

    def patch_user
      params.permit(:status)
    end

end

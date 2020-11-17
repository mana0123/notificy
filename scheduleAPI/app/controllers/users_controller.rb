class UsersController < ApplicationController

before_action :user_exist, only: [:show, :update, :destroy]

  # GET /users
  def index
    @users = User.all
    render status: :ok 
  end

  # POST /users
  def create

    @user = User.create(post_user)
    render status: :ok 

  end

  # GET /users/:id
  def show
    render status: :ok 
  end

 # PUT /users/:id
  def update

    @user_new = User.new(post_user)
    # 変更項目がない場合、bad_requestを返却
    if @user == @user_new
      render status: :bad_request,
             json: { data: { message: @user.errors } }
    end

    if @user.update(status: params[:status])
      render status: :ok, 
             json: { data: { user: @user } }
    else
      render status: :bad_request, 
             json: { data: { user: @user.errors } }
    end
  end

  # DELETE /users/:id
  def destroy
    @user.destroy
    render status: :ok 
  end

  private
    def user_exist
      unless @user = User.find_by(line_id: params[:id])
        @messages = ["id(#{params[:id]}) is not found"]
        render status: :not_found
        return
      end
    end

    def post_user
      params.permit(:user_type, :line_id, :status)
             .merge(status: 1)
    end

end

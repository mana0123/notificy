class SessionsController < ApplicationController
  before_action :not_logged_in_user, only: [:new, :create, :line_new, :line_user]
  before_action :logged_in_user, only: [:destroy]

  def new
  end

  def create
    user = User.find_by(name: params[:session][:name])
    if user && user.authenticate(params[:session][:password])
      log_in(user)
      redirect_to '/users'
    else
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to '/login'
  end

  def line_new 
    @id = params[:id]
    @token = params[:token]
  end

  def line_user 
    user = User.find_by(id: params[:id])
    if (user && !user.access_digest.nil? && 
        user.authenticate_access_token?(params[:token]) && 
       !user.access_token_expired?)
      log_in(user)
      user.update_attributes(access_digest: nil, access_at: nil)
      redirect_to "/users/#{user.name}"
      return
    else
      redirect_to "/login"
    end
      
  end
end

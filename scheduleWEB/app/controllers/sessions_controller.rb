class SessionsController < ApplicationController

  def new
    not_logged_in_user
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
end

class ApplicationController < ActionController::Base

  include SessionsHelper
  include ConnApi

  private
    
    def logged_in_admin_or_current_user(user_name)
      unless current_user.user_type == 1 ||
             user_name == current_user.name
        redirect_to "/users/#{current_user.name}"
      end
    end

    def logged_in_admin_user
      unless current_user.user_type == 1
        redirect_to "/users/#{current_user.name}"
      end
    end

    def logged_in_user
      unless logged_in?
        redirect_to login_url
      end
    end

    def not_logged_in_user
      if logged_in?
        redirect_to users_url
      end
    end

end

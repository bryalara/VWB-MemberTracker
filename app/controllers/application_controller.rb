# frozen_string_literal: true

class ApplicationController < ActionController::Base
  

  def admin_verify
    authenticate_userlogin!
    if !User.exists?(email: current_userlogin.email)
      redirect_to registration_user_path
    # elsif User.find_by(email: current_userlogin.email).role.zero?
    #   redirect_to root_path, notice: 'You are not an Admin'
    end
  end

  def check_user
    if userlogin_signed_in?
      if(User.exists?(email: current_userlogin.email))
        return (User.find_by(email: current_userlogin.email))
      end
    end
  end

      

end

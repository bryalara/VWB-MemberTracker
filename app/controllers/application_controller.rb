# frozen_string_literal: true

class ApplicationController < ActionController::Base
  
  # check whether if the user is an admin
  def admin_verify
    authenticate_userlogin!
    # if not, redirect to register a user
    redirect_to registration_user_path unless User.exists?(email: current_userlogin.email)
  end

  #check whether if the user is logined
  def check_user
    return nil unless userlogin_signed_in?
    return User.find_by(email: current_userlogin.email) if User.exists?(email: current_userlogin.email)
  end
end

# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def admin_verify
    authenticate_userlogin!
    redirect_to registration_user_path unless User.exists?(email: current_userlogin.email)
  end

  def check_user
    return nil unless userlogin_signed_in?
    return User.find_by(email: current_userlogin.email) if User.exists?(email: current_userlogin.email)
  end
end

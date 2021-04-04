# frozen_string_literal: true

class ApplicationController < ActionController::Base

  helper_method :admin?

  def admin_verify
    authenticate_userlogin!
    unless User.exists?(email: current_userlogin.email)
      redirect_to registration_user_path
      # elsif User.find_by(email: current_userlogin.email).role.zero?
      #   redirect_to root_path, notice: 'You are not an Admin'
    end
  end

  def check_user
    User.find_by(email: current_userlogin.email) if userlogin_signed_in? && User.exists?(email: current_userlogin.email)
  end

  def admin?
    user = User.find_by(email: current_userlogin.email) if userlogin_signed_in? && User.exists?(email: current_userlogin.email)
    return user.role == User::role_types["Admin"]
  end
end

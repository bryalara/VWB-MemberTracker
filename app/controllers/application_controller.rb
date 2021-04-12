# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :admin?

  # check whether if the user is an admin
  def admin_verify
    authenticate_userlogin!
    # if not, redirect to register a user
    redirect_to registration_user_path unless User.exists?(email: current_userlogin.email)
  end

  # check whether if the user is logined
  def check_user
    return nil unless userlogin_signed_in?

    User.find_by(email: current_userlogin.email)
  end

  def admin?
    user = check_user
    user.role == User.role_types['Admin']
  end
end

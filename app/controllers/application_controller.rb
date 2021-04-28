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

  # Returns true if the user is an admin.
  def admin?
    user = check_user
    user.role == User.role_types['Admin']
  end

  # Returns true if the admin is to super admin (org email)
  def super_user?
    user = check_user
    # user.email == 'vetswithoutborderstamu@gmail.com'
    user.email == 'bryalara@tamu.edu'
  end
end

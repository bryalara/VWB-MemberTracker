# frozen_string_literal: true

class UsersController < ApplicationController
  protect_from_forgery with: :exception
  before_action :authenticate_userlogin! && :admin_verify, except: %i[create registration edit]
  # http_basic_authenticate_with name: "vwb", password: "password"

  def index
    Rails.logger.info 'Inside Index'
    # Check that auth user is signed in and an approved admin, else redirect
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to member_dashboard_path if !@auth || @auth.role.zero? || @auth.approved == false
    # Guard case that returns so that index stops processing. Prevents double renders/redirects
    return unless @auth && (@auth.role == 1) && @auth.approved == true

    # Grabing params used for sorting users on view
    @order = params[:order] == 'true'
    @attr = params[:attr]
    @attr ||= 'last'
    ord = @order == true ? :DESC : :ASC
    @users = User.get_users(true, @attr, ord)
    # This responds to when we want to download approved users as csv.
    # Using Gaurd case above makes sure only approved admins have access
    respond_to do |format|
      format.html
      format.csv do
        # make it available to output 2 csv files
        # { send_data @users.to_csv, filename: "member-emails-#{Date.today}.csv" }
        case params[:format_data]
        when 'email'
          # to_csv is to only output users' emails
          send_data @users.to_csv, filename: "member-emails-#{Time.zone.today}.csv"
        when 'all'
          # to_csv_backup is to output users' all
          send_data @users.to_csv_backup, filename: "member-info-#{Time.zone.today}.csv"
        end
      end
    end
  end

  # import csv
  def import
    # Check that auth user is signed in and an approved admin, else redirect
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to member_dashboard_path if !@auth || @auth.role.zero? || @auth.approved == false
    # Guard case that returns so that index stops processing. Prevents double renders/redirects
    return unless @auth && (@auth.role == 1) && @auth.approved == true

    wmsg = User.my_import(params[:file])
    if wmsg.length.positive?
      # flash[:notice] ||= []
      wmsg.each do |msg|
        flash[:notice] ||= []
        flash[:notice] << msg.to_s
      end
      redirect_to users_path
    else
      redirect_to users_path, success: "Users' information imported from csv file"
    end
  end

  def show
    # Find user entity from params id to be displayed
    @user = User.find(params[:id])
    @msg = params[:notice]
    # Check that auth user is signed in and an approved member, else redirect
    @auth = User.find_by(email: current_userlogin.email)
    if @auth
      # redirect to logged in users info, prevent them from viewing other users' data
      redirect_to users_path(@auth) if @auth.role.zero?
    else
      redirect_to registration_user_path
    end
  end

  def new
    # Auth used to check if user is already created
    @auth = User.find_by(email: current_userlogin.email)
    # Creating new user entity to be created and filled in
    @user = User.new
  end

  def create
    # Auth used to check if user is already created
    @auth = User.find_by(email: current_userlogin.email)
    # logged_auth used to determine what params to pass depending on admin or not
    logged_auth = false
    logged_auth = @auth.role.zero? ? false : true if @auth
    # Creating user with params determine by logged_auth. Fals means logged in is a member or new registering user
    @user = User.new(logged_auth ? user_params : member_params)
    # Handling case that user is saved properly
    if @user.save
      # Outputing newly created user information
      logger.debug "User: (#{@user.firstName} #{@user.lastName}) created @ #{Time.zone.now}"
      logger.debug @user.inspect
      # Redirecting to show user information
      redirect_to @user, notice: "Successfully created new user: #{"#{@user.firstName} #{@user.lastName}"}."
    elsif @user.valid?
      flash[:notice] = "Successfully created new user: #{"#{@user.firstName} #{@user.lastName}"}."
    else
      # Outputing errors if user params were not valid
      @msg = @user.errors.full_messages[0]
      logger.warn "Creating user input field error: #{@msg}"
      flash.now[:notice] = @msg
      render :new
    end
  end

  def edit
    @auth = User.find_by(email: current_userlogin.email)
    unless @auth
      redirect_to member_dashboard_path
      return
    end
    @user = User.find(params[:id])
    # Changine user to auth if logged in user is not admin.
    # Makes sure that non admins can only edit their own information
    @user = @auth if @auth.role.zero?
  end

  def update
    @auth = User.find_by(email: current_userlogin.email)
    unless @auth
      redirect_to member_dashboard_path
      return
    end
    @user = User.find(params[:id])
    # if auth is not an Admin, make the user that is being edited the same as the user thats logged
    # prevents members from editing other members
    @user = @auth if @auth.role.zero?
    # if member editing, updates all params except role, points, and approved
    # else if admin, allow admin to update all attributes of the user
    if @user.update(@auth.role.zero? ? member_params : user_params)
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @auth = User.find_by(email: current_userlogin.email)
    # Redirects to member_dashboard if not an approved admin, not processing delete
    if !@auth || @auth.role.zero? || @auth.approved == false
      redirect_to member_dashboard_path
      return
    end
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path, notice: "Succesfully deleted user: #{@user.firstName} #{@user.lastName}."
  end

  def pending_approval
    @auth = User.find_by(email: current_userlogin.email)
    user_ids = params[:users_ids]
    @select_all = params[:select_all] == 'true'
    unless @auth
      redirect_to new_user_path
      return
    end
    if @auth.role.zero? || @auth.approved == false
      redirect_to member_dashboard_path
      return
    end
    # Post request are when admin selected pendingUsers for approval or deletion
    if request.post? && user_ids
      action_users = User.where(id: user_ids)
      # Handling approving selected users
      if params[:commit]
        action_users.each do |user|
          flash[:notice] ||= []
          if user.update(approved: true)
            flash[:notice] << ("#{user.firstName} #{user.lastName} has been approved")
          else
            flash[:alert] << ("#{user.firstName} #{user.lastName} could not be approved")
          end
        end
      # Handling deleting selected users
      elsif params[:delete]
        action_users.each do |user|
          flash[:notice] ||= []
          if user.destroy
            flash[:notice] << ("#{user.firstName} #{user.lastName} has been removed")
          else
            flash[:alert] << ("#{user.firstName} #{user.lastName} had an error while trying to be removed")
          end
        end
      end
      # Redirecting to previous page after processing, in case redirection fails it goes to users_path
      redirect_back(fallback_location: users_path)
      return
    end
    # Processing display of pending approval user, similar to index
    @order = params[:order] == 'true'
    @attr = params[:attr]
    @attr ||= 'last'
    ord = @order == true ? :DESC : :ASC
    @users = User.get_users(false, @attr, ord)
  end

  def member_dashboard
    @auth = User.find_by(email: current_userlogin.email)
    @user = User.find_by(email: current_userlogin.email)
    @display = 0
    redirect_to new_user_path and return unless @user
  end

  def registration
    @auth = User.find_by(email: current_userlogin.email)
    if @auth
      redirect_to member_dashboard_path
      return
    end
    @user = User.new
  end

  private

  def user_params
    params.require(:user).permit(:email, :role, :firstName, :lastName, :phoneNumber, :classification, :tShirtSize,
                                 :optInEmail, :participationPoints, :approved)
  end

  def member_params
    params.require(:user).permit(:email, :firstName, :lastName, :phoneNumber, :classification, :tShirtSize,
                                 :optInEmail)
  end
end

# frozen_string_literal: true

class UsersController < ApplicationController
  protect_from_forgery with: :exception
  before_action :authenticate_userlogin! && :admin_verify, except: %i[create registration edit]
  # http_basic_authenticate_with name: "vwb", password: "password"

  def index
    Rails.logger.info 'whatever'
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to member_dashboard_path if !@auth || @auth.role.zero? || @auth.approved == false

    @order = params[:order] == 'true'
    @attr = params[:attr]
    @attr ||= 'last'
    ord = @order == true ? :DESC : :ASC
    @users = User.get_users(true, @attr, ord)
    @latest_new = User.order('created_at').last
    @latest_update = User.order('updated_at').last

    return unless @auth && (@auth.role == 1) && @auth.approved == true

    respond_to do |format|
      format.html
      format.csv { send_data @users.to_csv, filename: "member-emails-#{Time.zone.today}.csv" }
    end
  end

  def import
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to member_dashboard_path if !@auth || @auth.role.zero? || @auth.approved == false
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
    @user = User.find(params[:id])
    @msg = params[:notice]
    @auth = User.find_by(email: current_userlogin.email)
    if @auth
      redirect_to users_path(@auth) if @auth.role.zero?
    else
      redirect_to registration_user_path
    end
  end

  def new
    @auth = User.find_by(email: current_userlogin.email)
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      logger.debug "User: (#{@user.firstName} #{@user.lastName}) created @ #{Time.zone.now}"
      logger.debug @user.inspect
      redirect_to @user, notice: "Successfully created new user: #{"#{@user.firstName} #{@user.lastName}"}."
    elsif @user.valid?
      flash[:notice] = "Successfully created new user: #{"#{@user.firstName} #{@user.lastName}"}."
    else
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
  end

  def update
    @auth = User.find_by(email: current_userlogin.email)
    unless @auth
      redirect_to member_dashboard_path
      return
    end
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @auth = User.find_by(email: current_userlogin.email)
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

    if request.post? && user_ids
      action_users = User.where(id: user_ids)

      if params[:commit]
        action_users.each do |user|
          flash[:notice] ||= []
          if user.update(approved: true)
            flash[:notice] << ("#{user.firstName} #{user.lastName} has been approved")
          else
            flash[:alert] << ("#{user.firstName} #{user.lastName} could not be approved")
          end
        end

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

      redirect_back(fallback_location: users_path)
    end

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
    unless @user
      redirect_to new_user_path
      return
    end
    @show_all = (params[:show_all] == 'true')
    @user_events = []
    @user_pevents = []

    @display = params[:show_all] ? @user.events.length : 5

    i = 0
    logger.debug @user.event_users.first.form.attached?
    logger.debug "++++++++++++++++++++"
    @user.event_users.order(:created_at).each do |e|
      logger.debug e
      @user_events.append(["[#{e.event.points} pts] - #{e.event.name} @ #{e.event.startDate}", e])
      i += 1
      break if i >= @display
    end
    @num_events = i
    i = 0
    @user.point_events.each do |e|
      @user_pevents.append(e.name)
      i += 1
      break if i >= @display
    end
    @num_point_events = i
  end

  def registration
    @auth = User.find_by(email: current_userlogin.email)
    if @auth
      redirect_to member_dashboard_path
      return
    end
    @user = User.new
  end


  def user_event_update
    @auth = User.find_by(email: current_userlogin.email)
    if !@auth || @auth.approved == false
      redirect_to member_dashboard_path
      return
    end
    @user = User.find_by(email: current_userlogin.email)
    
    @event_user= params[:id]
    
    file = params[:event_user][:uploads]
    
    redirect_to member_dashboard_path unless @event_user || file

    if request.post? && file
      logger.debug "_________________________"
      event_user_id= params[:event_user][:id]
      logger.debug params[:event_user][:id]
      logger.debug "_________________________"
      logger.debug file
      @user.event_users.find(event_user_id).form.attach(File.new(file[Tempfile]))

      logger.debug @user.event_users.find(event_user_id).form.attached?
    end



    
    
  end


  private

  def user_params
    params.require(:user).permit(:email, :role, :firstName, :lastName, :phoneNumber, :classification, :tShirtSize,
                                 :optInEmail, :participationPoints, :approved, uploads:[])
  end
end

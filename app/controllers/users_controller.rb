# frozen_string_literal: true

class UsersController < ApplicationController
  protect_from_forgery with: :exception
  before_action :authenticate_userlogin! && :admin_verify, except: %i[create registration edit]
  # http_basic_authenticate_with name: "vwb", password: "password"

  def index
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to memberDashboard_path if !@auth || @auth.role.zero? || @auth.approved == false

    @order = params[:order] == 'true'
    @attr = params[:attr]
    @attr ||= 'last'
    ord = @order == true ? :'DESC' : :'ASC'
    @users = case @attr
             when 'first'
               User.where(approved: true).order("UPPER(\"users\".\"firstName\") #{ord}")
             when 'last'
               User.where(approved: true).order("UPPER(\"users\".\"lastName\") #{ord}")
             when 'role'
               User.where(approved: true).order("\"users\".\"role\" #{ord}")
             when 'class'
              #  User.where(approved: true).order("\"users\".\"classification\" #{ord}")
              User.where(approved: true).order("CASE \"users\".\"classification\" 
                                            WHEN 'Freshman'  THEN '0'
                                            WHEN 'Sophomore' THEN '1'
                                            WHEN 'Junior'    THEN '2'
                                            WHEN 'Senior'    THEN '3'
                                              END #{ord}")
             when 'size'
              User.where(approved: true).order("CASE \"users\".\"tShirtSize\" 
                                            WHEN 'XXXS' THEN '0'
                                            WHEN 'XXS'  THEN '1'
                                            WHEN 'XS'   THEN '2'
                                            WHEN 'S'    THEN '3'
                                            WHEN 'M'    THEN '4'
                                            WHEN 'L'    THEN '5'
                                            WHEN 'XL'   THEN '6'
                                            WHEN 'XXL'  THEN '7'
                                            WHEN 'XXXL' THEN '8'
                                              END #{ord}")
             when 'points'
               User.where(approved: true).order("\"users\".\"participationPoints\" #{ord}")
             else
               User.where(approved: true).order('UPPER("users"."lastName") ASC')
             end
    @latestNew = User.order('created_at').last
    @latestUpdate = User.order('updated_at').last

    if @auth && (@auth.role == 1) && @auth.approved==true
      respond_to do |format|
        format.html
        format.csv { send_data @users.to_csv, filename: "member-emails-#{Date.today}.csv" }
      end
    end
  end

  def import
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to memberDashboard_path if !@auth || @auth.role.zero? || @auth.approved == false
    wmsg = User.my_import(params[:file])
    if wmsg.length.positive?
      # flash[:notice] ||= []
      wmsg.each do |msg|
        flash[:notice] ||=[]
        flash[:notice] <<  msg.to_s
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
      puts('user saved')
      redirect_to @user, notice: "Successfully created new user: #{"#{@user.firstName} #{@user.lastName}"}."
    elsif @user.valid?
      flash[:notice] = "Successfully created new user: #{"#{@user.firstName} #{@user.lastName}"}."
    else
      @msg = @user.errors.full_messages[0]
      puts @msg
      flash.now[:notice] = @msg
      render :new
    end
  end

  def edit
    @auth = User.find_by(email: current_userlogin.email)
    @user = User.find(params[:id])
  end

  def update
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
      redirect_to memberDashboard_path
      return
    end
    @user = User.find(params[:id])
    tmp = @user
    @user.destroy

    redirect_to users_path, notice: "Succesfully deleted user: #{@user.firstName} #{@user.lastName}."
  end

  def pendingApproval
    @auth = User.find_by(email: current_userlogin.email)
    user_ids = params[:users_ids]
    @selectAll = params[:selectAll] == 'true'
  
    if !@auth
      redirect_to new_user_path
      return
    elsif @auth.role.zero? || @auth.approved == false
      redirect_to memberDashboard_path
      return
    end

    if request.post?
      begin
        if user_ids
          actionUsers=User.where(:id => user_ids)

          if params[:commit]
            actionUsers.each do |user|
              flash[:notice] ||=[]
              if user.update(approved: true)
                flash[:notice] << (user.firstName+' '+user.lastName+' has been approved')
              else
                flash[:alert] << (user.firstName+' '+user.lastName+' could not be approved')
              end
            end 

          elsif params[:delete]
            actionUsers.each do |user|
              flash[:notice] ||=[]
              if user.destroy
                flash[:notice] << (user.firstName+' '+user.lastName+' has been removed')
              else
                flash[:alert] << (user.firstName+' '+user.lastName+' had an error while trying to be removed')
              end
            end
          end
        end
        redirect_back(fallback_location: users_path)
      end
    end

    @order = params[:order] == 'true'
    @attr = params[:attr]
    @attr ||= 'last'
    ord = @order == true ? :'DESC' : :'ASC'
    @users =case @attr
            when 'first'
              User.where(approved: false).order("UPPER(\"users\".\"firstName\") #{ord}")
            when 'last'
              User.where(approved: false).order("UPPER(\"users\".\"lastName\") #{ord}")
            when 'role'
              User.where(approved: false).order("\"users\".\"role\" #{ord}")
            when 'class'
            User.where(approved: false).order("CASE \"users\".\"classification\" 
                                          WHEN 'Freshman'  THEN '0'
                                          WHEN 'Sophomore' THEN '1'
                                          WHEN 'Junior'    THEN '2'
                                          WHEN 'Senior'    THEN '3'
                                            END #{ord}")
            when 'size'
            User.where(approved: false).order("CASE \"users\".\"tShirtSize\" 
                                          WHEN 'XXXS' THEN '0'
                                          WHEN 'XXS'  THEN '1'
                                          WHEN 'XS'   THEN '2'
                                          WHEN 'S'    THEN '3'
                                          WHEN 'M'    THEN '4'
                                          WHEN 'L'    THEN '5'
                                          WHEN 'XL'   THEN '6'
                                          WHEN 'XXL'  THEN '7'
                                          WHEN 'XXXL' THEN '8'
                                            END #{ord}")
            when 'points'
              User.where(approved: false).order("\"users\".\"participationPoints\" #{ord}")
            else
              User.where(approved: false).order('UPPER("users"."lastName") ASC')
            end
  end

  def memberDashboard
    @auth = User.find_by(email: current_userlogin.email)
    @user = User.find_by(email: current_userlogin.email)
    @display = 0
    unless @user
      redirect_to new_user_path
      return
    end
    @showAll = (params[:showAll] == 'true')
    @userEvents = []
    @userPEvents = []

    @display = if params[:showAll]
                 @user.events.length
               else
                 5
               end

    i = 0
    @user.events.order(:created_at).each do |e|
      @userEvents.append("[#{e.points} pts] - #{e.name} @ #{e.startDate}")
      i += 1
      break if i >= @display
    end
    @numEvents = i
    i = 0
    @user.point_events.each do |e|
      @userPEvents.append(e.name)
      i += 1
      break if i >= @display
    end
    @numPointEvents = i
  end

  def registration
    @auth = User.find_by(email: current_userlogin.email)
    @user = User.new
  end

  private

  def user_params
    params.require(:user).permit(:email, :role, :firstName, :lastName, :phoneNumber, :classification, :tShirtSize,
                                 :optInEmail, :participationPoints, :approved)
  end
end

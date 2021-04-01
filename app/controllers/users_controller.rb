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
    @attr ||= 'first'
    ord = 'ASC'
    ord = if @order == true
            'ASC'
          else
            'DESC'
          end
    @users = case @attr
             when 'first'
               User.where(approved: true).order("\"users\".\"firstName\" #{ord}")
             when 'last'
               User.where(approved: true).order("\"users\".\"lastName\" #{ord}")
             when 'role'
               User.where(approved: true).order("\"users\".\"role\" #{ord}")
             when 'class'
               User.where(approved: true).order("\"users\".\"classification\" #{ord}")
             when 'size'
               User.where(approved: true).order("\"users\".\"tShirtSize\" #{ord}")
             when 'points'
               User.where(approved: true).order("\"users\".\"participationPoints\" #{ord}")
             else
               User.where(approved: true).order('"users"."lastName" ASC')
             end
    @latestNew = User.order('created_at').last
    @latestUpdate = User.order('updated_at').last

    if @auth && (@auth.role == 1) && @auth.approved==true
      respond_to do |format|
        format.html
        format.csv do
          #make it available to output 2 csv files
          #{ send_data @users.to_csv, filename: "member-emails-#{Date.today}.csv" }
          if (params[:format_data] == 'email')
            #to_csv is to only output users' emails
            send_data @users.to_csv, filename: "member-emails-#{Date.today}.csv"
          elsif (params[:format_data] == 'all')
            #to_csv_backup is to output users' all
            send_data @users.to_csv_backup, filename: "member-info-#{Date.today}.csv" 
          end
        end
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
        puts(msg)
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
    if !@auth
      redirect_to new_user_path
      return
    elsif @auth.role.zero? || @auth.approved == false
      redirect_to memberDashboard_path
      return
    end

    @order = params[:order] == 'true'
    @attr = params[:attr]
    @attr ||= 'first'
    ord = 'ASC'
    ord = if @order == true
            'ASC'
          else
            'DESC'
          end
    @users = case @attr
             when 'first'
               User.where(approved: false).order("\"users\".\"firstName\" #{ord}")
             when 'last'
               User.where(approved: false).order("\"users\".\"lastName\" #{ord}")
             when 'role'
               User.where(approved: false).order("\"users\".\"role\" #{ord}")
             when 'class'
               User.where(approved: false).order("\"users\".\"classification\" #{ord}")
             when 'size'
               User.where(approved: false).order("\"users\".\"tShirtSize\" #{ord}")
             when 'points'
               User.where(approved: false).order("\"users\".\"participationPoints\" #{ord}")
             else
               User.where(approved: false).order('"users"."lastName" ASC')
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

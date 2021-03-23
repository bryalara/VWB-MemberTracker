class UsersController < ApplicationController
  protect_from_forgery with: :exception
  before_action :authenticate_userlogin!
  # http_basic_authenticate_with name: "vwb", password: "password"

  def index
    
    @auth = User.find_by_email(current_userlogin.email)
    if(!@auth)
      redirect_to new_user_path
      return
    elsif(@auth.role==0 || @auth.approved==false)
      redirect_to memberDashboard_path
      return
    end

    @order=params[:order]== "true"
    @attr= params[:attr]
    unless(@attr)
      @attr='first'
    end
    ord='ASC'
    if(@order==true)
      ord='ASC' 
    else
      ord='DESC'
    end
    case @attr
    when 'first'
      @users= User.where(approved: true).order( '"users"."firstName" '+ord )
    when 'last'
      @users= User.where(approved: true).order( '"users"."lastName" '+ord )
    when 'role'
      @users= User.where(approved: true).order( '"users"."role" '+ord )
    when 'class'
      @users= User.where(approved: true).order( '"users"."classification" '+ord )
    when 'size'
      @users= User.where(approved: true).order( '"users"."tShirtSize" '+ord )
    when 'points'
      @users= User.where(approved: true).order( '"users"."participationPoints" '+ord )
    else
      @users= User.where(approved: true).order( '"users"."lastName" ASC' )
    end
    @latestNew = User.order("created_at").last
    @latestUpdate = User.order("updated_at").last


    if(@auth)
      if(@auth.role==1)
        respond_to do |format|
          format.html
          format.csv { send_data @users.to_csv, filename: "member-emails-#{Date.today}.csv" }
        end
      end
    end


  end

  def import
    @auth = User.find_by_email(current_userlogin.email)
    if(!@auth || @auth.role==0 || @auth.approved==false)
      redirect_to memberDashboard_path
      return
    end
    wmsg=User.my_import(params[:file])
    if(wmsg.length > 0)
      flash[:notice]=""
      wmsg.each do |msg|
        puts(msg)
        flash[:notice]+= '|'+msg
      end
      redirect_to users_path
    else  
      redirect_to users_path, success: "Users' information imported from csv file"
    end
  end

  def show
    @msg= params[:notice]
    @auth = User.find_by_email(current_userlogin.email)
    if(@auth)
      if(@auth.role==0)
        redirect_to users_path(@auth)                              
      end
    else  
      redirect_to new_user_path
    end
    @user = User.find(params[:id])
  end
  
  def new
    @auth = User.find_by_email(current_userlogin.email)
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      puts("user saved")
      redirect_to users_path(@user), notice:"Successfully created new user: #{@user.firstName+' '+@user.lastName}."
    else
      if @user.valid?
        puts("Valid")
        flash[:notice] = "Successfully created new user: #{@user.firstName+' '+@user.lastName}."
      else
        puts("Not valid")
        @msg = @user.errors.full_messages[0]
        puts @msg
        flash.now[:notice] = @msg
        render :new
      end
    end
  end

  def edit
    @auth = User.find_by_email(current_userlogin.email)
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
    @auth = User.find_by_email(current_userlogin.email)
    if(!@auth || @auth.role==0 || @auth.approved==false)
      redirect_to memberDashboard_path
      return
    end
    @user = User.find(params[:id])
    tmp = @user
    @user.destroy

    redirect_to users_path, notice:"Succesfully deleted user: "+@user.firstName+" "+@user.lastName+"."
  end

  def pendingApproval
    @auth = User.find_by_email(current_userlogin.email)
    if(!@auth || @auth.role==0 || @auth.approved==false)
      redirect_to memberDashboard_path
      return
    end
    @users = User.where(approved: false)
  end

  def memberDashboard
    @user = User.find_by_email(current_userlogin.email)
    @display=0
    unless (@user)
      redirect_to new_user_path
      return
    end
    @showAll =(params[:showAll]=='true')
    @userEvents=[]
    @userPEvents=[]

    unless (params[:showAll])
      @display=5
    else
      @display=@user.events.length
    end

    i=0
    @user.events.order(:created_at).each do |e| 
      @userEvents.append('['+e.points.to_s+' pts] - '+e.name+' @ '+e.startDate.to_s)
      i+=1
      if i >= @display
        break
      end
    end
    @numEvents= i
    i=0
    @user.point_events.each do |e| 
      @userPEvents.append(e.name)
      i+=1
      if i >= @display
        break
      end
    end
    @numPointEvents= i
  end

  private
    def user_params
      params.require(:user).permit(:email, :role, :firstName, :lastName, :phoneNumber, :classification, :tShirtSize, :optInEmail, :participationPoints, :approved)
    end
end

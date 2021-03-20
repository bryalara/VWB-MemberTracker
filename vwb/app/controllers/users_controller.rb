class UsersController < ApplicationController
  protect_from_forgery with: :exception
  before_action :authenticate_userlogin! && :admin_verify, except: [:create, :registration, :edit]
  # http_basic_authenticate_with name: "vwb", password: "password"
  def index
    @user = User.find_by_email(current_userlogin.email)
    @users= User.where(approved: true)
  end

  def import
    User.my_import(params[:file])
    redirect_to users_path, notice: "Users' information imported from csv file"
  end
 
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to @user
    else
      if @user.valid?
        @msg="New user: "+@user.firstName+" "+@user.lastName+" created"
      else
        @msg = @user.errors.full_messages[0]
        puts @msg
        flash.now[:notice] = @msg
        render :new
      end
    end
  end

  def edit
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
    @user = User.find(params[:id])
    tmp = @user
    @user.destroy

    redirect_to users_path, notice:"Succesfully deleted user: "+@user.firstName+" "+@user.lastName+"."
  end

  def pendingApproval
    @users = User.where(approved: false)
  end

  def registration
    @user = User.new
  end

  private
    def user_params
      params.require(:user).permit(:email, :role, :firstName, :lastName, :phoneNumber, :classification, :tShirtSize, :optInEmail, :participationPoints, :approved)
    end
end

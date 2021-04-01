# frozen_string_literal: true

class PointEventController < ApplicationController
  protect_from_forgery with: :exception
  before_action :authenticate_userlogin! && :admin_verify, except: %i[create registration]

  def index
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to memberDashboard_path if !@auth || @auth.role.zero? || @auth.approved == false
    @pointEvents = PointEvent.all
  end

  def show
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to memberDashboard_path if !@auth || @auth.role.zero? || @auth.approved == false
    @pointEvent = PointEvent.find(params[:id])
  end

  def new
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to memberDashboard_path if !@auth || @auth.role.zero? || @auth.approved == false
    @pointEvent = PointEvent.new
  end

  def create
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to memberDashboard_path if !@auth || @auth.role.zero? || @auth.approved == false
    @pointEvent = PointEvent.new(pointEventParams)

    if @pointEvent.save
      flash[:notice] = "Successfully created #{@pointEvent.name}."
      redirect_to event_index_path
    else
      flash[:notice] = 'Please fill in the required fields.'
      render :new
    end
  end

  def edit
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to memberDashboard_path if !@auth || @auth.role.zero? || @auth.approved == false
    @pointEvent = PointEvent.find(params[:id])
  end

  def update
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to memberDashboard_path if !@auth || @auth.role.zero? || @auth.approved == false
    @pointEvent = PointEvent.find(params[:id])

    if @pointEvent.update(pointEventParams)
      flash[:notice] = "Successfully edited #{@pointEvent.name}."
      redirect_to @pointEvent
    else
      render :edit
    end
  end

  def delete
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to memberDashboard_path if !@auth || @auth.role.zero? || @auth.approved == false
    @pointEvent = PointEvent.find(params[:id])
  end

  def destroy
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to memberDashboard_path if !@auth || @auth.role.zero? || @auth.approved == false
    @pointEvent = PointEvent.find(params[:id])
    @pointEvent.destroy

    flash[:notice] = "Successfully deleted #{@pointEvent.name}."
    redirect_to event_index_path
  end

  def qr
    @pointEvent = PointEvent.find(params[:id])
    @qrCode = RQRCode::QRCode.new("#{request.protocol}#{request.host_with_port}" + attend_point_event_path(@pointEvent))
  end

  def attend
    @pointEvent = PointEvent.find(params[:id])
    @user = User.where(email: current_userlogin.email).first

    if request.post?
      begin
        if @user.approved == true
          @pointEvent.users << @user
          flash[:notice] = "Successfully attended #{@pointEvent.name}!"
        else
          flash[:notice] =
            "Could not attend the points event because #{@user.email} has not been approved by an administrator."
          redirect_to attend_point_event_path(@pointEvent)
        end
      rescue ActiveRecord::RecordNotUnique
        flash[:notice] = "You have already attended #{@pointEvent.name}!"
        redirect_to attend_point_event_path(@pointEvent)
      end
    end
  end

  def destroy_user
    @pointEvent = PointEvent.find(params[:id])
    @user = User.find(params[:user_id])

    flash[:notice] = if @pointEvent.users.delete(@user)
                       "Successfully removed #{@user.firstName} #{@user.lastName} from #{@pointEvent.name}."
                     else
                       "#{@user.firstName} #{@user.lastName} has already been removed from #{@pointEvent.name}."
                     end
    redirect_to edit_point_event_path(@pointEvent)
  end

  private

  def pointEventParams
    params.require(:point_event).permit(:points, :name, :description)
  end
end

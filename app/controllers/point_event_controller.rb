# frozen_string_literal: true

class PointEventController < ApplicationController
  protect_from_forgery with: :exception
  before_action :authenticate_userlogin! && :admin_verify, except: %i[create registration]

  def index
    @auth = User.find_by(email: current_userlogin.email)
    @point_events = PointEvent.all
  end

  def show
    @auth = User.find_by(email: current_userlogin.email)
    @point_event = PointEvent.find(params[:id])
  end

  def new
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to memberDashboard_path if !@auth || @auth.role.zero? || @auth.approved == false
    @point_event = PointEvent.new
  end

  def create
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to memberDashboard_path if !@auth || @auth.role.zero? || @auth.approved == false
    @point_event = PointEvent.new(point_event_params)

    if @point_event.save
      flash[:notice] = "Successfully created #{@point_event.name}."
      redirect_to event_index_path
    else
      flash[:notice] = 'Please fill in the required fields.'
      render :new
    end
  end

  def edit
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to memberDashboard_path if !@auth || @auth.role.zero? || @auth.approved == false
    @point_event = PointEvent.find(params[:id])

    if params[:firstName] || params[:lastName] || params[:email]
      @users = User.search(params[:firstName], params[:lastName], params[:email])
    end
  end

  def update
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to memberDashboard_path if !@auth || @auth.role.zero? || @auth.approved == false
    @point_event = PointEvent.find(params[:id])

    if @point_event.update(point_event_params)
      flash[:notice] = "Successfully edited #{@point_event.name}."
      redirect_to @point_event
    else
      render :edit
    end
  end

  def delete
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to memberDashboard_path if !@auth || @auth.role.zero? || @auth.approved == false
    @point_event = PointEvent.find(params[:id])
  end

  def destroy
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to memberDashboard_path if !@auth || @auth.role.zero? || @auth.approved == false
    @point_event = PointEvent.find(params[:id])
    @point_event.destroy

    flash[:notice] = "Successfully deleted #{@point_event.name}."
    redirect_to event_index_path
  end

  # Creates @qr_code which can be used to display a qr code to attend a point event.
  def qr
    @point_event = PointEvent.find(params[:id])
    @qr_code = RQRCode::QRCode.new("#{request.protocol}#{request.host_with_port}" + attend_point_event_path(@point_event))
  end

  # Page for user to attend a point event if they have already signed up for it. If the client does a POST, it will set the
  # user attended attribute in the event_attendee to true.
  def attend
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to memberDashboard_path unless @auth
    @point_event = PointEvent.find(params[:id])
    @user = User.where(email: current_userlogin.email).first

    return unless request.post?

    attendance = PointEventAttendee.find_by(user_id: @user.id, point_event_id: @point_event.id)
    if attendance
      attendance.attended = true
      attendance.save
      flash[:notice] = "Successfully attended #{@point_event.name}!"
      redirect_to event_index_path
    else
      flash[:notice] = "Could not attend #{@point_event.name} because you did not sign up for the engagement."
      redirect_to attend_point_event_path(@point_event)
      nil
    end
  end

  # Removes the user from a point event they attended.
  def destroy_user
    @point_event = PointEvent.find(params[:id])
    @user = User.find(params[:user_id])

    flash[:notice] = if @point_event.users.delete(@user)
                       "Successfully removed #{@user.firstName} #{@user.lastName} from #{@point_event.name}."
                     else
                       "#{@user.firstName} #{@user.lastName} has already been removed from #{@point_event.name}."
                     end
    redirect_to edit_point_event_path(@point_event)
  end

  # Allows users to sign up by putting them in the point_event_attendees join table.
  def sign_up
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to memberDashboard_path unless @auth
    @point_event = PointEvent.find(params[:id])
    @user = User.where(email: current_userlogin.email).first

    return unless request.post?

    begin
      if @user
        @point_event.users << @user
        flash[:notice] = "Successfully signed up for #{@point_event.name}!"
        redirect_to event_index_path
      end
    rescue ActiveRecord::RecordNotUnique
      flash[:notice] = "You have already signed up for #{@point_event.name}!"
      redirect_to sign_up_point_event_path(@point_event)
      nil
    rescue NoMethodError
      flash[:alert] = "Cannot signup for #{@point_event.name}! The engagement has reached its capacity."
      redirect_to sign_up_point_event_path(@point_event)
    end
  end

  # Forces a selected user into a point event
  def force_in
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to memberDashboard_path unless @auth

    point_event = PointEvent.find(params[:point_event_id])
    user = User.find(params[:user_id])

    point_event_attendee = PointEventAttendee.new(point_event_attendee_params)

    begin
      # validate: false forces the user in, even if the capacity is full.
      if point_event_attendee.save(validate: false)
        flash[:notice] = "Successfully forced the user in!"
        redirect_to edit_point_event_path(point_event)
      else
        redirect_to edit_point_event_path(point_event)
      end
    # If the user has already signed up for the event...
    rescue ActiveRecord::RecordNotUnique
      attendee = PointEventAttendee.find_by(user_id: user.id, point_event_id: point_event.id)

      # and has attended
      if attendee.attended
        flash[:alert] = "#{user.firstName} #{user.lastName} has already attended this engagement."

      # but has not attended
      else
        attendee.attended = true
        attendee.save
        flash[:notice] = "Successfully forced #{user.firstName} #{user.lastName} to attend this engagement."
      end
      redirect_to edit_point_event_path(event)
    end
  end

  private
  def point_event_params
    params.require(:point_event).permit(:points, :name, :description, :capacity)
  end

  def point_event_attendee_params
    params.permit(:point_event_id, :user_id, :attended)
  end
end

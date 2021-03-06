# frozen_string_literal: true

class PointEventController < ApplicationController
  protect_from_forgery with: :exception
  before_action :authenticate_userlogin! && :admin_verify, except: %i[create]

  def index
    @auth = User.find_by(email: current_userlogin.email)
    @point_events = PointEvent.all
  end

  # export csv for backup, could download 2 csv
  def export_csv
    @point_events = PointEvent.all
    respond_to do |format|
      format.html
      format.csv do
        # make it available to output 2 csv files
        # { send_data @users.to_csv, filename: "member-emails-#{Date.today}.csv" }
        if params[:format_data] == 'events'
          # to_csv is to only output events' details
          send_data @point_events.to_csv, filename: "engagement-events-#{Time.zone.today}.csv"
        else
          # to_csv_backup is to output users' all info
          send_data @point_events.to_csv_users, filename: "engagement-members-#{Time.zone.today}.csv"
        end
      end
    end
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

    @users = User.search(params[:firstName], params[:lastName], params[:email]) if params[:firstName] || params[:lastName] || params[:email]
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
    # If the user has signed up
    if attendance
      # If the user has not attended
      if !attendance.attended
        attendance.attended = true
        attendance.save
        flash[:notice] = "Successfully attended #{@point_event.name}!"
        redirect_to @point_event
      else
        flash[:notice] = "Could not attend #{@point_event.name} because you did not sign up for the engagement."
        redirect_to @point_event
        nil
      end
    elsif @point_event.capacity.positive?
      # If the capacity is greater than zero, require signing up for the engagement to attend.
      flash[:notice] = "Could not attend #{@point_event.name} because you did not sign up for the engagement."
      redirect_to @point_event
      nil
    else
      # Force a user in and set them as attended.
      @point_event.users << @user
      attendance = PointEventAttendee.find_by(user_id: @user.id, point_event_id: @point_event.id)
      attendance.attended = true
      attendance.save
      flash[:notice] = "Successfully attended #{@point_event.name}!"
      redirect_to @point_event
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
    redirect_to member_dashboard_path unless @auth
    @point_event = PointEvent.find(params[:id])
    @user = User.where(email: current_userlogin.email).first

    return unless request.post?

    begin
      if @user
        @point_event.users << @user
        flash[:notice] = "Successfully signed up for #{@point_event.name}!"
        redirect_to @point_event
      end
    rescue ActiveRecord::RecordNotUnique
      flash[:notice] = "You have already signed up for #{@point_event.name}!"
      redirect_to @point_event
      nil
    rescue NoMethodError
      flash[:alert] = "Cannot signup for #{@point_event.name}! The engagement has reached its capacity."
      redirect_to @point_event
    end
  end

  # Forces a selected user into a point event
  def force_in
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to member_dashboard_path unless @auth

    point_event = PointEvent.find(params[:point_event_id])
    user = User.find(params[:user_id])

    point_event_attendee = PointEventAttendee.new(point_event_attendee_params)

    begin
      # validate: false forces the user in, even if the capacity is full.
      flash[:notice] = 'Successfully forced the user in!' if point_event_attendee.save(validate: false)
      redirect_to edit_point_event_path(point_event)

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
      redirect_to edit_point_event_path(point_event)
    end
  end

  # Allows users to upload documents
  def upload_user
    @auth = check_user
    redirect_to member_dashboard_path unless @auth
    @point_event = PointEvent.find(params[:point_event_id])
    @user = User.find(params[:user_id])

    return unless request.post?

    attendance = PointEventAttendee.find_by(user_id: @user.id, point_event_id: @point_event.id)
    attendance.documents.purge
    attendance.documents.attach(params[:documents])

    flash[:notice] = 'Successfully submitted document(s).'
    redirect_to @point_event
  end

  # import csv
  def import
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to member_dashboard_path if !@auth || @auth.role.zero? || @auth.approved == false
    wmsg = PointEvent.my_import(params[:file])
    if wmsg.length.positive?
      # flash[:notice] ||= []
      wmsg.each do |msg|
        flash[:notice] ||= []
        flash[:notice] << msg.to_s
      end
      redirect_to event_index_path
    else
      redirect_to event_index_path, success: "Events' information imported from csv file"
    end
  end

  # import csv
  def import_part
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to member_dashboard_path if !@auth || @auth.role.zero? || @auth.approved == false
    PointEvent.my_import_part(params[:file])
    redirect_to event_index_path
  end

  private

  def point_event_params
    params.require(:point_event).permit(:points, :name, :description, :capacity, documents: [])
  end

  def point_event_attendee_params
    params.permit(:point_event_id, :user_id, :attended, documents: [])
  end
end

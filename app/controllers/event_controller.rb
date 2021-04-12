# frozen_string_literal: true

class EventController < ApplicationController
  protect_from_forgery with: :exception

  before_action :authenticate_userlogin!
  def index
    @auth = User.find_by(email: current_userlogin.email)
    @events = Event.all
    @point_events = PointEvent.all
  end

  # export csv
  # another way to download csv other than what in the users
  def export_csv
    @events = Event.all
    # only allowed when user is an Admin
    respond_to do |format|
      format.html
      format.csv do
        # make it available to output 2 csv files
        # { send_data @users.to_csv, filename: "member-emails-#{Date.today}.csv" }
        if params[:format_data] == 'events'
          # to_csv is to only output users' emails
          send_data @events.to_csv, filename: "events-#{Time.zone.today}.csv"
        else
          # to_csv_backup is to output users' all info
          send_data @events.to_csv_users, filename: "event-attendees-#{Time.zone.today}.csv"
        end
      end
    end
  end

  def show
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to member_dashboard_path if !@auth || @auth.approved == false
    @event = Event.find(params[:id])
  end

  def new
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to member_dashboard_path if !@auth || @auth.role.zero? || @auth.approved == false
    @event = Event.new
  end

  def create
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to member_dashboard_path and return if !@auth || @auth.role.zero? || @auth.approved == false

    @event = Event.new(event_params)

    if @event.save
      flash[:notice] = "Successfully created #{@event.name}."
      redirect_to event_index_path
    else
      render :new
    end
  end

  def edit
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to member_dashboard_path unless @auth
    @event = Event.find(params[:id])

    @users = User.search(params[:firstName], params[:lastName], params[:email]) if params[:firstName] || params[:lastName] || params[:email]
  end

  def update
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to member_dashboard_path unless @auth
    @event = Event.find(params[:id])

    if @event.update(event_params)
      flash[:notice] = "Successfully edited #{@event.name}."
      redirect_to @event
    else
      render :edit
    end
  end

  def delete
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to member_dashboard_path if !@auth || @auth.role.zero? || @auth.approved == false
    @event = Event.find(params[:id])
  end

  def destroy
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to member_dashboard_path and return if !@auth || @auth.role.zero? || @auth.approved == false

    @event = Event.find(params[:id])
    @event.destroy

    flash[:notice] = "Successfully deleted #{@event.name}."
    redirect_to event_index_path
  end

  # Creates @qr_code which can be used to display a qr code to attend an event.
  def qr
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to member_dashboard_path unless @auth
    @event = Event.find(params[:id])
    @qr_code = RQRCode::QRCode.new("#{request.protocol}#{request.host_with_port}" + attend_event_path(@event))
  end

  # Page for user to attend an event if they have already signed up for it. If the client does a POST, it will set the
  # user attended attribute in the event_attendee to true.
  def attend
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to member_dashboard_path unless @auth
    @event = Event.find(params[:id])
    @user = User.where(email: current_userlogin.email).first

    return unless request.post?

    attendance = EventAttendee.find_by(user_id: @user.id, event_id: @event.id)
    if attendance
      attendance.attended = true
      attendance.save
      flash[:notice] = "Successfully attended #{@event.name}!"
      redirect_to event_index_path
    else
      flash[:notice] = "Could not attend #{@event.name} because you did not sign up for the event."
      redirect_to attend_event_path(@event)
      nil
    end
  end

  # Removes the user from an event they attended.
  def destroy_user
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to member_dashboard_path if !@auth || @auth.role.zero? || @auth.approved == false
    @event = Event.find(params[:id])
    @user = User.find(params[:user_id])

    flash[:notice] = if @event.users.delete(@user)
                       "Successfully removed #{@user.firstName} #{@user.lastName} from #{@event.name}."
                     else
                       "#{@user.firstName} #{@user.lastName} has already been removed from #{@event.name}."
                     end
    redirect_to edit_event_path(@event)
  end

  # Creates an ics file from events created and downloads it.
  def download_ics
    @events = Event.all
    cal = Icalendar::Calendar.new

    @events.each do |e|
      event = Icalendar::Event.new
      event.dtstart = e.startDate
      event.dtend = e.endDate
      event.summary = e.name
      event.description = e.description
      cal.add_event(event)
    end

    send_data cal.to_ical, type: 'text/calendar', disposition: 'attachment', filename: 'VWB Calendar.ics'
  end

  # Allows users to sign up by putting them in the event_attendees join table.
  def sign_up
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to member_dashboard_path unless @auth
    @event = Event.find(params[:id])
    @user = User.where(email: current_userlogin.email).first

    return unless request.post?

    begin
      if @user
        @event.users << @user
        flash[:notice] = "Successfully signed up for #{@event.name}!"
        redirect_to event_index_path
      end
    rescue ActiveRecord::RecordNotUnique
      flash[:notice] = "You have already signed up for #{@event.name}!"
      redirect_to sign_up_event_path(@event)
      nil
    rescue NoMethodError
      flash[:alert] = "Cannot signup for #{@event.name}! The event has reached its capacity."
      redirect_to sign_up_event_path(@event)
    end
  end

  # Forces a selected user into an event
  def force_in
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to member_dashboard_path unless @auth

    event = Event.find(params[:event_id])
    user = User.find(params[:user_id])

    event_attendee = EventAttendee.new(event_attendee_params)

    begin
      # validate: false forces the user in, even if the capacity is full.
      flash[:notice] = 'Successfully forced the user in!' if event_attendee.save(validate: false)
      redirect_to edit_event_path(event)

    # If the user has already signed up for the event...
    rescue ActiveRecord::RecordNotUnique
      attendee = EventAttendee.find_by(user_id: user.id, event_id: event.id)

      # and has attended
      if attendee.attended
        flash[:alert] = "#{user.firstName} #{user.lastName} has already attended this event."

      # but has not attended
      else
        attendee.attended = true
        attendee.save
        flash[:notice] = "Successfully forced #{user.firstName} #{user.lastName} to attend this event."
      end
      redirect_to edit_event_path(event)
    end
  end

  # import csv
  def import
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to member_dashboard_path if !@auth || @auth.role.zero? || @auth.approved == false
    wmsg = Event.my_import(params[:file])
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
      wmsg = Event.my_import_part(params[:file])
      redirect_to event_index_path
    end

  private

  def event_params
    params.require(:event).permit(:points, :name, :description, :startDate, :endDate, :capacity)
  end

  def event_attendee_params
    params.permit(:event_id, :user_id, :attended)
  end
end

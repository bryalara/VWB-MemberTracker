# frozen_string_literal: true

class EventController < ApplicationController
  protect_from_forgery with: :exception
  before_action :authenticate_userlogin! && :admin_verify, except: %i[create registration]
  def index
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to member_dashboard_path if !@auth || @auth.role.zero? || @auth.approved == false
    @events = Event.all
    @point_events = PointEvent.all
  end

  def show
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to member_dashboard_path if !@auth || @auth.role.zero? || @auth.approved == false
    @event = Event.find(params[:id])
  end

  def new
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to member_dashboard_path if !@auth || @auth.role.zero? || @auth.approved == false
    @event = Event.new
  end

  def create
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to member_dashboard_path if !@auth || @auth.role.zero? || @auth.approved == false
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
    redirect_to member_dashboard_path if !@auth
    @event = Event.find(params[:id])
  end

  def update
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to member_dashboard_path if !@auth
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
    redirect_to member_dashboard_path if !@auth || @auth.role.zero? || @auth.approved == false
    @event = Event.find(params[:id])
    @event.destroy

    flash[:notice] = "Successfully deleted #{@event.name}."
    redirect_to event_index_path
  end

  # Creates @qr_code which can be used to display a qr code to attend an event.
  def qr
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to member_dashboard_path if !@auth 
    @event = Event.find(params[:id])
    @qr_code = RQRCode::QRCode.new("#{request.protocol}#{request.host_with_port}" + attend_event_path(@event))
  end

  # Page for user to attend an event. If the client does a POST, it will try to add the user to the event.
  def attend
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to member_dashboard_path if !@auth
    @event = Event.find(params[:id])
    @user = User.where(email: current_userlogin.email).first

    return unless request.post?

    begin
      if @user.approved == true
        @event.users << @user
        flash[:notice] = "Successfully attended #{@event.name}!"
      else
        flash[:notice] =
          "Could not attend the event because #{@user.email} has not been approved by an administrator."
        redirect_to attend_event_path(@event)
        nil
      end
    rescue ActiveRecord::RecordNotUnique
      flash[:notice] = "You have already attended #{@event.name}!"
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

  # Creates an ics file from events created.
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

  private

  def event_params
    params.require(:event).permit(:points, :name, :description, :startDate, :endDate)
  end
end

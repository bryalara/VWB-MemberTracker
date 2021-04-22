class SpecialController < ApplicationController
  protect_from_forgery with: :exception
  before_action :authenticate_userlogin! && :admin_verify

  def index
    redirect_to member_dashboard_path and return unless super_user?

    reset_app = params[:reset] == 'true'
    # If param passed to reset, start reset process
    return unless reset_app
    # Getting all attributes to reset Active:Storage files
    member_events=EventAttendee.all
    member_point_events = PointEventAttendee.all
    events = Event.all
    point_events= PointEvent.all
    users = User.all
    # Purging documents from Acive:Storage first then destroying entity
    member_events.each do |e|
      e.documents.purge
      e.destroy
    end
    member_point_events.each do |e|
      e.documents.purge
      e.destroy
    end
    events.each do |e|
      e.documents.purge
      e.destroy
    end
    point_events.each do |e|
      e.documents.purge
      e.destroy
    end
    users.each do |u|
      u.destroy
    end
    # Database should be reset at this point
    # Recreating super admin entity to allow set up
    User.create(email: 'bryalara@tamu.edu', role: 1, firstName: 'VWB', lastName: 'TAMU', phoneNumber: 1231231234, classification: 'Senior', tShirtSize: 'M', optInEmail: true, participationPoints: 0, approved: true)
    redirect_to users_path, success: "Database has been reset"
  end
end

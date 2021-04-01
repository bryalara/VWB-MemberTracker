# frozen_string_literal: true

class EventController < ApplicationController
  protect_from_forgery with: :exception
  before_action :authenticate_userlogin! && :admin_verify, except: %i[create registration]

  def index
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to memberDashboard_path if !@auth || @auth.role.zero? || @auth.approved == false
    @events = Event.all
    @pointEvents = PointEvent.all
  end

  #export csv
  #another way to download csv other than what in the users
  def export_csv
    @events = Event.all
    if true
      respond_to do |format|
        format.html
        format.csv do
          #make it available to output 2 csv files
          #{ send_data @users.to_csv, filename: "member-emails-#{Date.today}.csv" }
          if (params[:format_data] == 'events')
            #to_csv is to only output users' emails
            send_data @events.to_csv, filename: "member-emails-#{Date.today}.csv"
          else
            #to_csv_backup is to output users' all info
            send_data @events.to_csv, filename: "member-emails-#{Date.today}.csv"
          end
        end
      end
    end
  end

  def show
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to memberDashboard_path if !@auth || @auth.role.zero? || @auth.approved == false
    @event = Event.find(params[:id])
  end

  def new
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to memberDashboard_path if !@auth || @auth.role.zero? || @auth.approved == false
    @event = Event.new
  end

  def create
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to memberDashboard_path if !@auth || @auth.role.zero? || @auth.approved == false
    @event = Event.new(eventParams)

    if @event.save
      flash[:notice] = "Successfully created #{@event.name}."
      redirect_to event_index_path
    else
      render :new
    end
  end

  def edit
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to memberDashboard_path if !@auth
    @event = Event.find(params[:id])
  end

  def update
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to memberDashboard_path if !@auth
    @event = Event.find(params[:id])

    if @event.update(eventParams)
      flash[:notice] = "Successfully edited #{@event.name}."
      redirect_to @event
    else
      render :edit
    end
  end

  def delete
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to memberDashboard_path if !@auth || @auth.role.zero? || @auth.approved == false
    @event = Event.find(params[:id])
  end

  def destroy
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to memberDashboard_path if !@auth || @auth.role.zero? || @auth.approved == false
    @event = Event.find(params[:id])
    @event.destroy

    flash[:notice] = "Successfully deleted #{@event.name}."
    redirect_to event_index_path
  end

  def qr
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to memberDashboard_path if !@auth 
    @event = Event.find(params[:id])
    @qrCode = RQRCode::QRCode.new("#{request.protocol}#{request.host_with_port}" + attend_event_path(@event))
  end

  def attend
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to memberDashboard_path if !@auth
    @event = Event.find(params[:id])
    @user = User.where(email: current_userlogin.email).first

    if request.post?
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
  end

  # removes user from an event attended
  def destroy_user
    @auth = User.find_by(email: current_userlogin.email)
    redirect_to memberDashboard_path if !@auth || @auth.role.zero? || @auth.approved == false
    @event = Event.find(params[:id])
    @user = User.find(params[:user_id])

    flash[:notice] = if @event.users.delete(@user)
                       "Successfully removed #{@user.firstName} #{@user.lastName} from #{@event.name}."
                     else
                       "#{@user.firstName} #{@user.lastName} has already been removed from #{@event.name}."
                     end
    redirect_to edit_event_path(@event)
  end

  private

  def eventParams
    params.require(:event).permit(:points, :name, :description, :startDate, :endDate)
  end
end

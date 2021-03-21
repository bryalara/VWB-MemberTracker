class EventController < ApplicationController
	protect_from_forgery with: :exception
    before_action :authenticate_userlogin!
	def index
		@events = Event.all
		@pointEvents = PointEvent.all
	end

	def show
		@event = Event.find(params[:id])
	end

	def new
		@event = Event.new
	end

	def create
		@event = Event.new(eventParams)

		if @event.save
			flash[:notice] = "Successfully created #{@event.name}."
			redirect_to event_index_path
		else
			render :new
		end
	end

	def edit
		@event = Event.find(params[:id])
	end

	def update
		@event = Event.find(params[:id])

		if @event.update(eventParams)
			flash[:notice] = "Successfully edited #{@event.name}."
			redirect_to @event
		else
			render :edit
		end
	end

	def delete
		@event = Event.find(params[:id])
	end

	def destroy
		@event = Event.find(params[:id])
		@event.destroy

		flash[:notice] = "Successfully deleted #{@event.name}."
		redirect_to event_index_path
	end

	# Creates @qrCode which can be used to display a qr code to attend the event.
	def qr
		@event = Event.find(params[:id])
		@qrCode = RQRCode::QRCode.new("#{request.protocol}#{request.host_with_port}" + attend_event_path(@event))
	end

	# Page for user to attend an event. If the client does a POST command, it will try to add the user to the event.
	def attend
		@event = Event.find(params[:id])
		@user = User.where(email: current_userlogin.email).first

		if request.post?
			begin
				if @user.approved == true
					@event.users << @user
					flash[:notice] = "Successfully attended #{@event.name}!"
				else
					flash[:notice] = "Could not attend the event because #{@user.email} has not been approved by an administrator."
					redirect_to attend_event_path(@event)
				end
			rescue ActiveRecord::RecordNotUnique
				flash[:notice] = "You have already attended #{@event.name}!"
				redirect_to attend_event_path(@event)
			end
		end
	end

	# Removes the user from an event they attended.
	def destroy_user
		@event = Event.find(params[:id])
		@user = User.find(params[:user_id])

		if @event.users.delete(@user)
			flash[:notice] = "Successfully removed #{@user.firstName} #{@user.lastName} from #{@event.name}."
		else
			flash[:notice] = "#{@user.firstName} #{@user.lastName} has already been removed from #{@event.name}."
		end
		redirect_to edit_event_path(@event)
	end

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

		send_data cal.to_ical, type: 'text/calendar', disposition: 'attachment', filename: "VWB Calendar.ics"
	end

	private
		def eventParams
			params.require(:event).permit(:points, :name, :description, :startDate, :endDate)
		end
end

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

	def qr
		@event = Event.find(params[:id])
		@qrCode = RQRCode::QRCode.new("#{request.protocol}#{request.host_with_port}" + attend_event_path(@event))
	end

	def attend
		@event = Event.find(params[:id])
		@user = User.where(email: current_userlogin.email).first

		if request.post?
			begin 
				@event.users << @user
			rescue ActiveRecord::RecordNotUnique
				flash[:notice] = "You have already attended #{@event.name}!"
				redirect_to attend_event_path(@event)
			else
				flash[:notice] = "Successfully attended #{@event.name}!"
				# do nothing
			end
		end
	end

	private
		def eventParams
			params.require(:event).permit(:points, :name, :description, :startDate, :endDate)
		end
end

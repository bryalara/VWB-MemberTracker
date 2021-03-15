class EventController < ApplicationController
	protect_from_forgery with: :exception
    before_action :authenticate_userlogin! && :admin_verify, except: [:create, :registration]
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

		#if true
		if @event.save
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

		#if true
		if @event.update(eventParams)
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

		redirect_to event_index_path
	end

	private
		def eventParams
			params.require(:event).permit(:points, :name, :description, :eventType, :startDate, :endDate)
		end
end

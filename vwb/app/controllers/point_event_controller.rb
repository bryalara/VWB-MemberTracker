class PointEventController < ApplicationController
	protect_from_forgery with: :exception
    before_action :authenticate_userlogin!
	
	def index
		@pointEvents = PointEvent.all
	end

	def show
		@pointEvent = PointEvent.find(params[:id])
	end

	def new
		@pointEvent = PointEvent.new
	end

	def create
		@pointEvent = PointEvent.new(pointEventParams)

		#if true
		if @pointEvent.save
			redirect_to event_index_path
		else
			render :new
		end
	end

	def edit
		@pointEvent = PointEvent.find(params[:id])
	end

	def update
		@pointEvent = PointEvent.find(params[:id])

		#if true
		if @pointEvent.update(pointEventParams)
			redirect_to event_index_path
		else
			render :edit
		end
	end

	def delete
		@pointEvent = PointEvent.find(params[:id])
	end

	def destroy
		@pointEvent = PointEvent.find(params[:id])
		@pointEvent.destroy

		redirect_to event_index_path
	end

	private
		def pointEventParams
			params.require(:point_event).permit(:points, :name, :description, :eventType)
		end
end


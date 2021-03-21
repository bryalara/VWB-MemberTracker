class PointEventController < ApplicationController
	protect_from_forgery with: :exception
    before_action :authenticate_userlogin! && :admin_verify, except: [:create, :registration]
	
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

		if @pointEvent.save
			flash[:notice] = "Successfully created #{@pointEvent.name}."
			redirect_to event_index_path
		else
			flash[:notice] = "Please fill in the required fields."
			render :new
		end
	end

	def edit
		@pointEvent = PointEvent.find(params[:id])
	end

	def update
		@pointEvent = PointEvent.find(params[:id])

		if @pointEvent.update(pointEventParams)
			flash[:notice] = "Successfully edited #{@pointEvent.name}."
			redirect_to @pointEvent
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

	def qr
		@pointEvent = PointEvent.find(params[:id])
		@qrCode = RQRCode::QRCode.new("#{request.protocol}#{request.host_with_port}" + attend_point_event_path(@pointEvent))
	end

	def attend
		@pointEvent = PointEvent.find(params[:id])
		@user = User.where(email: current_userlogin.email).first

		if request.post?
			begin
				if @user.approved == true
					@pointEvent.users << @user
					flash[:notice] = "Successfully attended #{@pointEvent.name}!"
				else
					flash[:notice] = "Could not attend the points event because #{@user.email} has not been approved by an administrator."
					redirect_to attend_point_event_path(@pointEvent)
				end
			rescue ActiveRecord::RecordNotUnique
				flash[:notice] = "You have already attended #{@pointEvent.name}!"
				redirect_to attend_point_event_path(@pointEvent)
			end
		end
	end

	def destroy_user
		@pointEvent = PointEvent.find(params[:id])
		@user = User.find(params[:user_id])

		if @pointEvent.users.delete(@user)
			flash[:notice] = "Successfully removed #{@user.firstName} #{@user.lastName} from #{@pointEvent.name}."
		else
			flash[:notice] = "#{@user.firstName} #{@user.lastName} has already been removed from #{@pointEvent.name}."
		end
		redirect_to edit_point_event_path(@pointEvent)
	end

	private
		def pointEventParams
			params.require(:point_event).permit(:points, :name, :description)
		end
end


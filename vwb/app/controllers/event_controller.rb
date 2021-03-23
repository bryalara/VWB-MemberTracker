class EventController < ApplicationController
	protect_from_forgery with: :exception
    before_action :authenticate_userlogin! && :admin_verify, except: [:create, :registration]
	def index
		@auth = User.find_by_email(current_userlogin.email)
		if(!@auth || @auth.role==0 || @auth.approved==false)
			redirect_to memberDashboard_path
		end
		@events = Event.all
		@pointEvents = PointEvent.all
	end

	def show
		@event = Event.find(params[:id])
	end

	def new
		@auth = User.find_by_email(current_userlogin.email)
		if(!@auth || @auth.role==0 || @auth.approved==false)
			redirect_to memberDashboard_path
		end
		@event = Event.new
	end

	def create
		@auth = User.find_by_email(current_userlogin.email)
		if(!@auth || @auth.role==0 || @auth.approved==false)
			redirect_to memberDashboard_path
		end
		@event = Event.new(eventParams)

		if @event.save
			flash[:notice] = "Successfully created #{@event.name}."
			redirect_to event_index_path
		else
			render :new
		end
	end

	def edit
		@auth = User.find_by_email(current_userlogin.email)
		if(!@auth || @auth.role==0 || @auth.approved==false)
			redirect_to memberDashboard_path
		end
		@event = Event.find(params[:id])
	end

	def update
		@auth = User.find_by_email(current_userlogin.email)
		if(!@auth || @auth.role==0 || @auth.approved==false)
			redirect_to memberDashboard_path
		end
		@event = Event.find(params[:id])

		if @event.update(eventParams)
			flash[:notice] = "Successfully edited #{@event.name}."
			redirect_to @event
		else
			render :edit
		end
	end

	def delete
		@auth = User.find_by_email(current_userlogin.email)
		if(!@auth || @auth.role==0 || @auth.approved==false)
			redirect_to memberDashboard_path
		end
		@event = Event.find(params[:id])
	end

	def destroy
		@auth = User.find_by_email(current_userlogin.email)
		if(!@auth || @auth.role==0 || @auth.approved==false)
			redirect_to memberDashboard_path
		end
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
				if @user.approved == true
					@event.users << @user
					flash[:notice] = "Successfully attended #{@event.name}!"
				else
					flash[:notice] = "Could not attend the event because #{@user.email} has not been approved by an administrator."
					redirect_to attend_event_path(@event)
					return
				end
			rescue ActiveRecord::RecordNotUnique
				flash[:notice] = "You have already attended #{@event.name}!"
				redirect_to attend_event_path(@event)
				return
			end
		end
	end

	#removes user from an event attended
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

	private
		def eventParams
			params.require(:event).permit(:points, :name, :description, :startDate, :endDate)
		end
end

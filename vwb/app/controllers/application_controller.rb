class ApplicationController < ActionController::Base
    def admin_verify
        authenticate_userlogin!
        if ! User.exists?(email: current_userlogin.email)
            redirect_to registration_user_path
        elsif User.find_by_email(current_userlogin.email).role == 0
            redirect_to root_path, notice: "You are not an Admin"
        end
    end
end

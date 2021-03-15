class ApplicationController < ActionController::Base
    def admin_verify
        authenticate_userlogin!
        if User.find_by_email(current_userlogin.email).role == 0
            redirect_to root_path, notice: "You are not an Admin"
        end
    end
end

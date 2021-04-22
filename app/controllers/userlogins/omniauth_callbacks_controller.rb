# frozen_string_literal: true

# most of these are from the instruction

module Userlogins
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google_oauth2
      userlogin = Userlogin.from_google(from_google_params)

      if userlogin.present?
        sign_out_all_scopes
        flash[:success] = t 'devise.omniauth_callbacks.success', kind: 'Google'
        sign_in_and_redirect userlogin, event: :authentication
      else
        flash[:alert] =
          t 'devise.omniauth_callbacks.failure', kind: 'Google', reason: "#{auth.info.email} is not authorized."
        redirect_to new_userlogin_session_path
      end
    end

    protected

    def after_omniauth_failure_path_for(_scope)
      new_userlogin_session_path
    end

    # after signin, direct to the home page or the user did not exist before, then went to register the user
    def after_sign_in_path_for(_resource_or_scope)
      # stored_location_for(resource_or_scope) || root_path
      if User.exists?(email: current_userlogin.email)
        # request.env['omniauth.origin'] || stored_location_for(resource) || root_url
        root_url
      else
        registration_user_path
      end
    end

    private

    def from_google_params
      @from_google_params ||= {
        uid: auth.uid,
        email: auth.info.email,
        full_name: auth.info.name,
        avatar_url: auth.info.image
      }
    end

    def auth
      @auth ||= request.env['omniauth.auth']
    end
  end
end

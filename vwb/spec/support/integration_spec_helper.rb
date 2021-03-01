module IntegrationSpecHelper
	def login_with_oauth
		OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
			:uid => '12345',
			:info => {
				:full_name => 'Dummy Test',
				:email => 'test@gmail.com',
				:avatar_url => 'suprised_pikachu.png'
			}	
		})
		visit userlogin_google_oauth2_omniauth_authorize_path
	end
end
module IntegrationSpecHelper
	# below is set default to the default admin so that tge tests write before will not fail
	def login_with_oauth
		OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
			:uid => '12345',
			:info => {
				:full_name => 'Bryan Lara',
				:email => 'bryalara@tamu.edu',
				:avatar_url => 'suprised_pikachu.png'
			}	
		})
		# visit event_index_path
		visit userlogin_google_oauth2_omniauth_authorize_path
	end

	def login_with_oauth_member_registration
		OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
			:uid => '12245',
			:info => {
				:full_name => 'Yingtao Jiang',
				:email => 'entao@tamu.edu',
				:avatar_url => 'suprised_pikachu.png'
			}	
		})
		# visit event_index_path
		visit userlogin_google_oauth2_omniauth_authorize_path
	end
end
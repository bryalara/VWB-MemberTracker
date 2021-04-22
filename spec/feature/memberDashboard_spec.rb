require 'rails_helper'

RSpec.describe 'MemberDashboard', type: :feature do

	setup do
		#Logging in as new user
		login_with_oauth_member_registration
	end

	describe 'member dashboard' do
		it 'logged in user prompted to make account' do
			visit member_dashboard_path	
			
			expect(page).to have_content('REGISTRATION')
		end
	end

	describe 'Registering as a new member' do
		setup do
			#Creating member user
			visit member_dashboard_path
			
			fill_in 'user_email', with: OmniAuth.config.mock_auth[:google_oauth2][:info][:email]
			fill_in 'user_firstName', with: 'John'
			fill_in 'user_lastName', with: 'Doe'
			fill_in 'user_phoneNumber', with: '1234567890'
			select 'Sophomore', :from => 'user_classification'
			select 'M', :from => 'user_tShirtSize'
			check 'user_optInEmail'
			
			click_on 'Sign Up'
			sleep(1)
		end

		it 'new member is shown pending approval' do
			visit member_dashboard_path
			sleep(1)
			expect(page).to have_content('Hello, John Doe')
			expect(page).to have_content('Your account is pending approval.')
		end

		describe "Approved new member" do
			setup do
				#approving recent user as member
				sleep(1)
				user=User.find_by(email: OmniAuth.config.mock_auth[:google_oauth2][:info][:email])
				sleep(1)
				user.update(approved: true)
				sleep(1)
			end
			it 'new member is approved and shown member dashboard' do
				visit member_dashboard_path
				sleep(1)
				expect(page).to have_content('Hello, John Doe')
				expect(page).to have_content('Current Total Points: 0')
			end
			it 'member redirected to dashboard when trying to access users' do
				visit users_path
				sleep(1)
				expect(page).to have_content('Hello, John Doe')
				expect(page).to have_content('Current Total Points: 0')
			end
			it 'member able to edit their info' do
				visit member_dashboard_path
				sleep(1)
				click_link 'Edit info'
				sleep(1)
				fill_in 'user_firstName', with: 'Doe'
				fill_in 'user_lastName', with: 'John'
				sleep(1)
				click_on 'Update User'
				sleep(1)
				expect(page).to have_content('Hello, Doe John')
				expect(page).to have_content('Current Total Points: 0')
			end

			describe "Member Attending events " do
				setup do
					#changing user to admin to make event, will be changed back
					user=User.find_by(email: OmniAuth.config.mock_auth[:google_oauth2][:info][:email])
					user.role=1
					user.approved=true
					user.save!
					
					#creating 10 test events
					for i in 1..10 do
						visit new_event_path
						fill_in 'event_name', with: 'Test Event '+i.to_s
						fill_in 'event_description', with: 'Test Description'
						fill_in 'event_points', with: 5
						fill_in 'event_startDate', with: DateTime.now
						fill_in 'event_endDate', with: DateTime.now + 1.week
						
						click_on 'Add Event'
						
					end
					#reverting user to member role
					user=User.find_by(email: OmniAuth.config.mock_auth[:google_oauth2][:info][:email])
					user.role=0
					user.approved=true
					user.save!
					
				end
			end
		end	
    end
end

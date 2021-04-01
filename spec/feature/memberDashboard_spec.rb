require 'rails_helper'

RSpec.describe 'MemberDashboard', type: :feature do

	setup do
		#Logging in as new user
		login_with_oauth_member_registration
	end

	describe 'member dashboard' do
		it 'logged in user prompted to make account' do
			visit memberDashboard_path	
			sleep(1)
			expect(page).to have_content('Registration')
		end
	end

	describe 'Registering as a new member' do
		setup do
			#Creating member user
			visit memberDashboard_path
			
			fill_in 'user_email', with: OmniAuth.config.mock_auth[:google_oauth2][:info][:email]
			fill_in 'user_firstName', with: 'John'
			fill_in 'user_lastName', with: 'Doe'
			fill_in 'user_phoneNumber', with: '1234567890'
			select 'Sophomore', :from => 'user_classification'
			select 'M', :from => 'user_tShirtSize'
			check 'user_optInEmail'
			sleep(1)
			click_on 'Create User'
			sleep(1)
		end

		it 'new member is shown pending approval' do
			visit memberDashboard_path
			sleep(1)
			expect(page).to have_content('Hello, John Doe')
			expect(page).to have_content('Your account is pending approval.')
		end

		describe "Approved new member" do
			setup do
				#approving recent user as member
				user=User.find_by(email: OmniAuth.config.mock_auth[:google_oauth2][:info][:email])
				user.approved=true
				user.save!
				sleep(1)
			end
			it 'new member is approved and shown member dashboard' do
				visit memberDashboard_path
				sleep(1)
				expect(page).to have_content('Hello, John Doe')
				expect(page).to have_content('Current points: 0')
			end
			it 'member redirected to dashboard when trying to access users' do
				visit users_path
				sleep(1)
				expect(page).to have_content('Hello, John Doe')
				expect(page).to have_content('Current points: 0')
			end
			it 'member redirected to dashboard when trying to access events' do
				visit event_index_path
				sleep(1)
				expect(page).to have_content('Hello, John Doe')
				expect(page).to have_content('Current points: 0')
			end
			it 'member able to edit their info' do
				visit memberDashboard_path
				sleep(1)
				click_link 'Edit info'
				sleep(1)
				fill_in 'user_firstName', with: 'Doe'
				fill_in 'user_lastName', with: 'John'
				sleep(1)
				click_on 'Update User'
				sleep(1)
				expect(page).to have_content('Hello, Doe John')
				expect(page).to have_content('Current points: 0')
			end

			describe "Member Attending events " do
				setup do
					#changing user to admin to make event, will be changed back
					user=User.find_by(email: OmniAuth.config.mock_auth[:google_oauth2][:info][:email])
					user.role=1
					user.approved=true
					user.save!
					sleep(2)
					#creating 10 test events
					for i in 1..10 do
						visit new_event_path
						fill_in 'event_name', with: 'Test Event '+i.to_s
						fill_in 'event_description', with: 'Test Description'
						fill_in 'event_points', with: 5
						fill_in 'event_startDate', with: DateTime.now
						fill_in 'event_endDate', with: DateTime.now + 1.week
						sleep(2)
						click_on 'Add Event'
						sleep(2)
					end
					#reverting user to member role
					user=User.find_by(email: OmniAuth.config.mock_auth[:google_oauth2][:info][:email])
					user.role=0
					user.approved=true
					user.save!
					sleep(4)
				end
				describe "attending events" do
					it "member attend 1 event" do
						eventId= Event.first.id
						sleep(4)
						visit attend_event_path(:id => eventId)
						sleep(4)
						click_link 'attend'
						sleep(4)
						visit memberDashboard_path
						sleep(4)
						expect(page).to have_content('Hello, John Doe')
						expect(page).to have_content('Current points: 5')
					end
					it "member attend all event" do
						expectedPoints=0
						events= Event.order( :created_at )
						events.each do |event|
							eventId= event.id
							visit attend_event_path(:id => eventId)
							sleep(4)
							click_on 'attend'
							sleep(4)
							expectedPoints+= event.points
						end
						visit memberDashboard_path
						sleep(4)
						expect(page).to have_content('Hello, John Doe')
						expect(page).to have_content('Events (5):')
						expect(page).to have_content('Current points: '+expectedPoints.to_s)
						
						click_link 'Show All Events'
						sleep(1)
						expect(page).to have_content('Events ('+events.length.to_s+'):')

						click_link 'Only Show Recent Events'
						sleep(1)
						expect(page).to have_content('Events (5):')
						
					end
				end
			end
			
		end	
		
    end
end
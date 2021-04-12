require 'rails_helper'

RSpec.describe 'PointEvents', type: :feature do
	setup do
		login_with_oauth
	end

	describe 'Route for' do
		it 'index shows the right content' do
			visit event_index_path
			expect(page).to have_content('ENGAGEMENTS')
		end

		it 'sign_up shows the right content' do
			event = PointEvent.create!(name: 'Test Event',
				description: 'Test Description',
				points: 5,
				capacity: 5)
			visit sign_up_point_event_path(id: event.id)
			expect(page).to have_content('Test Event')
		end

		it 'qr shows the right content' do
			event = PointEvent.create!(name: 'Test Event',
				description: 'Test Description',
				points: 5,
				capacity: 5)
			visit qr_point_event_path(id: event.id)
			expect(page).to have_content('TEST EVENT')
		end

		it 'attend shows the right content' do
			event = PointEvent.create!(name: 'Test Event',
				description: 'Test Description',
				points: 5,
				capacity: 5)
			visit attend_point_event_path(id: event.id)
			expect(page).to have_content('TEST EVENT')
		end
	end

	describe 'Creating a new points event' do
		setup do 
			visit new_point_event_path
			fill_in 'point_event_name', with: 'Test Event'
			fill_in 'point_event_description', with: 'Test Description'
			fill_in 'point_event_points', with: 5
			fill_in 'point_event_capacity', with: 5
		end
		
		it 'is valid with valid inputs' do
			click_on 'Add Engagement'
			visit event_index_path
			expect(page).to have_content('Test Event')
		end

		it 'is valid without a description' do
			fill_in 'point_event_description', with: ""
			click_on 'Add Engagement'
			visit event_index_path
			expect(page).to have_content('Test Event')
		end

		it 'is not valid without a name' do
			fill_in 'point_event_name', with: nil
			click_on 'Add Engagement'
			visit event_index_path
			expect(page).to_not have_content('Test Description')
		end

		it 'is not valid without points' do
			fill_in 'point_event_points', with: nil
			click_on 'Add Engagement'
			visit event_index_path
			expect(page).to_not have_content('Test Event')
		end

		it 'is valid with 0 points' do
			fill_in 'point_event_points', with: 0
			click_on 'Add Engagement'
			visit event_index_path
			expect(page).to have_content('Test Event')
		end

		it 'is not valid with negative points' do
			fill_in 'point_event_points', with: -1
			click_on 'Add Engagement'
			visit event_index_path
			expect(page).to_not have_content('Test Event')
		end

		it 'is valid with a capacity of 0' do
			fill_in 'point_event_capacity', with: 0
			click_on 'Add Engagement'
			visit event_index_path
			expect(page).to have_content('Test Event')
		end

		it 'is not valid with a negative capacity' do
			fill_in 'point_event_capacity', with: -1
			click_on 'Add Engagement'
			visit event_index_path
			expect(page).to_not have_content('Test Event')
		end

		it 'is not valid without a capacity' do
			fill_in 'point_event_capacity', with: ""
			click_on 'Add Engagement'
			visit event_index_path
			expect(page).to_not have_content('Test Event')
		end
	end

	describe 'Reading an existing point event' do
		setup do
			event = PointEvent.create!(name: 'Test Event',
				description: 'Test Description',
				points: 5,
				capacity: 5)
			visit point_event_path(id: event.id)
		end

		it 'reads events correctly' do
			expect(page).to have_content('Test Event')
			expect(page).to have_content('Test Description')
			expect(page).to have_content('5')
		end
	end

	describe 'Updating a point event' do
		setup do
			event = PointEvent.create!(name: 'Test Event',
				description: 'Test Description',
				points: 5,
				capacity: 5)
			visit edit_point_event_path(id: event.id)
		end

		it 'is valid with valid changes' do
			fill_in 'point_event_name', with: "Edited Event Name"
			click_on 'Save Changes'
			visit event_index_path
			expect(page).to have_content('Edited Event Name')
		end

		it 'is valid with the description deleted' do
			fill_in 'point_event_name', with: "Edited Event Name"
			fill_in 'point_event_description', with: nil
			click_on 'Save Changes'
			visit event_index_path
			expect(page).to have_content('Edited Event Name')
		end

		it 'is not valid without a name' do
			fill_in 'point_event_name', with: nil
			fill_in 'point_event_description', with: "Edited Test Description"
			click_on 'Save Changes'
			visit event_index_path
			expect(page).to_not have_content('Edited Test Description')
		end

		it 'is not valid without points' do
			fill_in 'point_event_points', with: nil
			fill_in 'point_event_description', with: "Edited Test Description"
			click_on 'Save Changes'
			visit event_index_path
			expect(page).to_not have_content('Edited Test Description')
		end

		it 'is valid with 0 points' do
			fill_in 'point_event_points', with: 0
			fill_in 'point_event_description', with: "Edited Test Description"
			click_on 'Save Changes'
			visit event_index_path
			expect(page).to have_content('Edited Test Description')
		end

		it 'is not valid with negative points' do
			fill_in 'point_event_points', with: -5
			fill_in 'point_event_description', with: "Edited Test Description"
			click_on 'Save Changes'
			visit event_index_path
			expect(page).to_not have_content('Edited Test Description')
		end

		it 'is valid with a capacity of 0' do
			fill_in 'point_event_capacity', with: 0
			fill_in 'point_event_description', with: "Edited Test Description"
			click_on 'Save Changes'
			visit event_index_path
			expect(page).to have_content('Edited Test Description')
		end

		it 'is not valid with a negative capacity' do
			fill_in 'point_event_capacity', with: -1
			fill_in 'point_event_description', with: "Edited Test Description"
			click_on 'Save Changes'
			visit event_index_path
			expect(page).to_not have_content('Edited Test Description')
		end

		it 'is not valid without a capacity' do
			fill_in 'point_event_capacity', with: ""
			fill_in 'point_event_description', with: "Edited Test Description"
			click_on 'Save Changes'
			visit event_index_path
			expect(page).to_not have_content('Edited Test Description')
		end
	end

	describe 'Deleting a points event' do
		it 'succeeded in deleting one event' do
			event = PointEvent.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						capacity: 5)
			visit event_index_path
			expect(page).to have_content('Test Event')

			visit delete_point_event_path(id: event.id)
			sleep(0.5)
			click_on 'delete-btn'
			sleep(0.5)

			wait = Selenium::WebDriver::Wait.new ignore: Selenium::WebDriver::Error::NoSuchAlertError
			alert = wait.until { page.driver.browser.switch_to.alert }
			alert.accept

			expect(page).to have_content('Successfully deleted Test Event')
		end

		it 'succeeded in deleting three events' do
			event1 = PointEvent.create!(name: 'Test Event 1',
						description: 'Test Description 1',
						points: 5,
						capacity: 5)
			event2 = PointEvent.create!(name: 'Test Event 2',
						description: 'Test Description 2',
						points: 5,
						capacity: 5)
			event3 = PointEvent.create!(name: 'Test Event 3',
						description: 'Test Description 3',
						points: 5,
						capacity: 5)

			visit event_index_path
			expect(page).to have_content('Test Event 1')
			expect(page).to have_content('Test Event 2')
			expect(page).to have_content('Test Event 3')

			visit delete_point_event_path(id: event2.id)
			sleep(0.5)
			click_on 'delete-btn'
			sleep(0.5)

			wait = Selenium::WebDriver::Wait.new ignore: Selenium::WebDriver::Error::NoSuchAlertError
			alert1 = wait.until { page.driver.browser.switch_to.alert }
			alert1.accept

			expect(page).to have_content('Test Event 1')
			expect(page).to have_content('Successfully deleted Test Event 2')
			expect(page).to have_content('Test Event 3')

			visit delete_point_event_path(id: event1.id)
			sleep(0.5)
			click_on 'delete-btn'
			sleep(0.5)

			alert2 = wait.until { page.driver.browser.switch_to.alert }
			alert2.accept

			expect(page).to have_content('Successfully deleted Test Event 1')
			expect(page).to_not have_content('Test Event 2')
			expect(page).to have_content('Test Event 3')

			visit delete_point_event_path(id: event3.id)
			sleep(0.5)
			click_on 'delete-btn'
			sleep(0.5)
			
			alert3 = wait.until { page.driver.browser.switch_to.alert }
			alert3.accept

			expect(page).to_not have_content('Test Event 1')
			expect(page).to_not have_content('Test Event 2')
			expect(page).to have_content('Successfully deleted Test Event 3')
		end
	end

	describe "Removing a user from a points event" do
		it "succeeded in removing a user from a points event" do
			event = PointEvent.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						capacity: 5)


			visit sign_up_point_event_path(event)
			expect(page).to have_content('Test Event')
			expect(page).to have_content('Hello bryalara@tamu.edu')

			click_on 'Click to sign up!'
			expect(page).to have_content("Successfully signed up for Test Event!")

			visit attend_point_event_path(event)
			expect(page).to have_content('TEST EVENT')
			expect(page).to have_content('Registered User: Bryan Lara')

			click_link 'Attend'
			expect(page).to have_content("Successfully attended Test Event!")

			visit edit_point_event_path(event)
			expect(page).to have_content('bryalara@tamu.edu')
			expect(page).to have_content('Remove')

			sleep(0.5)
			click_on 'Remove'
			sleep(0.5)
			
			wait = Selenium::WebDriver::Wait.new ignore: Selenium::WebDriver::Error::NoSuchAlertError
			alert = wait.until { page.driver.browser.switch_to.alert }
			alert.accept

			expect(page).to have_content("Attendance")
			expect(page).to_not have_content('bryalara@tamu.edu')
		end
	end

	describe "When signing up for a point event" do
		event = PointEvent.new
		setup do
			event = PointEvent.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						capacity: 2)
		end

		it "will allow registered and approved users to sign up" do
			visit sign_up_point_event_path(event)
			expect(page).to have_content("Engagement: Test Event")
			expect(page).to have_content("Hello bryalara@tamu.edu")

			click_on 'Click to sign up!'
			expect(page).to have_content("Successfully signed up for Test Event!")
		end

		it "shows the correct amount of users that have signed up" do
			visit event_index_path
			expect(page).to have_content("0 / 2")

			visit sign_up_point_event_path(event)
			expect(page).to have_content("Engagement: Test Event")
			expect(page).to have_content("Hello bryalara@tamu.edu")

			click_on 'Click to sign up!'
			expect(page).to have_content("Successfully signed up for Test Event!")

			visit event_index_path
			expect(page).to have_content("1 / 2")
		end

		it "shows the users that have signed up" do
			visit event_index_path
			expect(page).to have_content("0 / 2")

			visit point_event_path(event)
			expect(page).to_not have_content("bryalara@tamu.edu")

			visit sign_up_point_event_path(event)
			expect(page).to have_content("Engagement: Test Event")
			expect(page).to have_content("Hello bryalara@tamu.edu")

			click_on 'Click to sign up!'
			expect(page).to have_content("Successfully signed up for Test Event!")

			visit event_index_path
			expect(page).to have_content("1 / 2")

			visit point_event_path(event)
			expect(page).to have_content("bryalara@tamu.edu")
			expect(page).to have_content("N/A")
		end

		it "will notify users have already signed up if they try to sign up twice" do
			visit sign_up_point_event_path(event)
			expect(page).to have_content("Engagement: Test Event")
			expect(page).to have_content("Hello bryalara@tamu.edu")

			click_on 'Click to sign up!'
			expect(page).to have_content("Successfully signed up for Test Event!")

			visit sign_up_point_event_path(event)
			expect(page).to have_content("Engagement: Test Event")
			expect(page).to have_content("Hello bryalara@tamu.edu")
			
			click_on 'Click to sign up!'
			expect(page).to have_content("You have already signed up for Test Event!")
		end

		it "will allow registered but not approved users to sign up" do
			user = User.create!(email: 'dummy@tamu.edu',
								role: 0,
								firstName: 'Feature',
								lastName: 'Testing',
								phoneNumber: '1231231234',
								tShirtSize: 'M',
								participationPoints: 5,
								classification: 'Senior',
								optInEmail: true,
								approved: false)
			login_with_oauth_as("Feature Testing", "dummy@tamu.edu")

			visit sign_up_point_event_path(event)
			expect(page).to have_content("Engagement: Test Event")
			expect(page).to have_content("Hello dummy@tamu.edu")

			click_on 'Click to sign up!'
			expect(page).to have_content("Successfully signed up for Test Event!")
		end

		it "will not allow unregistered users to sign up" do
			login_with_oauth_as("Feature Testing", "dummy@tamu.edu")
			visit sign_up_point_event_path(event)

			expect(page).to_not have_content("Engagement: Test Event")
		end

		it "will not allow users to sign up if it is full" do
			visit sign_up_point_event_path(event)
			expect(page).to have_content("Engagement: Test Event")
			expect(page).to have_content("Hello bryalara@tamu.edu")

			click_on 'Click to sign up!'
			expect(page).to have_content("Successfully signed up for Test Event!")

			user = User.create!(email: 'dummy@tamu.edu',
								role: 0,
								firstName: 'Feature',
								lastName: 'Testing',
								phoneNumber: '1231231234',
								tShirtSize: 'M',
								participationPoints: 5,
								classification: 'Senior',
								optInEmail: true,
								approved: true)
			login_with_oauth_as("Feature Testing", "dummy@tamu.edu")
			visit sign_up_point_event_path(event)
			expect(page).to have_content("Engagement: Test Event")
			expect(page).to have_content("Hello dummy@tamu.edu")

			click_on 'Click to sign up!'
			expect(page).to have_content("Successfully signed up for Test Event!")

			user2 = User.create!(email: 'dummy2@tamu.edu',
								role: 0,
								firstName: 'Feature',
								lastName: 'Testing',
								phoneNumber: '1231231234',
								tShirtSize: 'M',
								participationPoints: 5,
								classification: 'Senior',
								optInEmail: true,
								approved: true)
			login_with_oauth_as("Feature Testing", "dummy2@tamu.edu")
			visit sign_up_point_event_path(event)
			expect(page).to have_content("Engagement: Test Event")
			expect(page).to have_content("Hello dummy2@tamu.edu")

			click_on 'Click to sign up!'
			expect(page).to have_content("Cannot signup for Test Event! The engagement has reached its capacity.")
		end

		it "will allow users to sign up if the capacity is 0" do
			event.capacity = 0
			event.save

			visit sign_up_point_event_path(event)
			expect(page).to have_content("Engagement: Test Event")
			expect(page).to have_content("Hello bryalara@tamu.edu")

			click_on 'Click to sign up!'
			expect(page).to have_content("Successfully signed up for Test Event!")
		end
	end

	describe "When attending a point event" do
		event = PointEvent.new

		setup do
			event = PointEvent.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						capacity: 2)
		end

		it "will not allow users that have not signed up to attend" do
			visit attend_point_event_path(event)
			expect(page).to have_content('TEST EVENT')
			expect(page).to have_content('Registered User: Bryan Lara')

			click_link 'Attend'
			expect(page).to have_content("Could not attend Test Event because you did not sign up for the engagement.")
		end

		it "will allow registered and approved users that have signed up to attend" do
			visit sign_up_point_event_path(event)
			expect(page).to have_content("Engagement: Test Event")
			expect(page).to have_content("Hello bryalara@tamu.edu")

			click_on 'Click to sign up!'
			expect(page).to have_content("Successfully signed up for Test Event!")

			visit attend_point_event_path(event)
			expect(page).to have_content('TEST EVENT')
			expect(page).to have_content('Registered User: Bryan Lara')

			click_link 'Attend'
			expect(page).to have_content("Successfully attended Test Event!")
		end

		it "will allow registered but not approved users that have signed up to attend" do
			user = User.create!(email: 'dummy@tamu.edu',
								role: 0,
								firstName: 'Feature',
								lastName: 'Testing',
								phoneNumber: '1231231234',
								tShirtSize: 'M',
								participationPoints: 5,
								classification: 'Senior',
								optInEmail: true,
								approved: false)
			login_with_oauth_as("Feature Testing", "dummy@tamu.edu")

			visit sign_up_point_event_path(event)
			expect(page).to have_content("Engagement: Test Event")
			expect(page).to have_content("Hello dummy@tamu.edu")

			click_on 'Click to sign up!'
			expect(page).to have_content("Successfully signed up for Test Event!")

			visit attend_point_event_path(event)
			expect(page).to have_content('TEST EVENT')
			expect(page).to have_content('Registered User: Feature Testing')

			click_link 'Attend'
			expect(page).to have_content("Successfully attended Test Event!")
		end

		it "will not allow unregistered users to attend" do
			login_with_oauth_as("Feature Testing", "dummy@tamu.edu")
			visit attend_point_event_path(event)
			expect(page).to have_content("REGISTRATION")
		end

		
		describe "with a capacity of 0" do
			it "will allow users who have not signed up for it to attend" do
				event.capacity = 0
				event.save

				visit attend_point_event_path(event)
				expect(page).to have_content('TEST EVENT')
				expect(page).to have_content('Registered User: Bryan Lara')
	
				click_link 'Attend'
				expect(page).to have_content("Successfully attended Test Event!")
			end
		end
	end

	describe "When forcing users into a point event" do
		point_event = PointEvent.new
		setup do
			point_event = PointEvent.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						capacity: 1)
		end

		it "is possible when the user has not signed up for it" do
			visit edit_point_event_path(point_event)
			expect(page).to have_content("Force a user to attend the engagement")

			fill_in 'firstName', with: 'Bry'
			sleep(0.5)
			click_on 'Search for users'
			sleep(0.5)

			expect(page).to have_content("Force in")
			sleep(0.5)
			click_on 'Force in'
			sleep(0.5)

			expect(page).to have_content("Successfully")
		end

		it "is possible when the user has signed up for it but not attended" do
			visit sign_up_point_event_path(point_event)
			expect(page).to have_content("Engagement: Test Event")
			expect(page).to have_content("Hello bryalara@tamu.edu")
			sleep(0.5)
			click_on 'Click to sign up!'
			sleep(0.5)
			expect(page).to have_content("Successfully signed up for Test Event!")

			visit edit_point_event_path(point_event)
			expect(page).to have_content("Force a user to attend the engagement")

			fill_in 'firstName', with: 'Bry'
			sleep(0.5)
			click_on 'Search for users'
			sleep(0.5)

			expect(page).to have_content("Force in")
			sleep(0.5)
			click_on 'Force in'
			sleep(0.5)
			expect(page).to have_content("Successfully forced")
		end

		it "is possible even when the point event is full" do
			user = User.create!(email: 'dummy@tamu.edu',
								role: 0,
								firstName: 'Feature',
								lastName: 'Testing',
								phoneNumber: '1231231234',
								tShirtSize: 'M',
								participationPoints: 5,
								classification: 'Senior',
								optInEmail: true,
								approved: false)
			login_with_oauth_as("Feature Testing", "dummy@tamu.edu")

			visit sign_up_point_event_path(point_event)
			expect(page).to have_content("Engagement: Test Event")
			expect(page).to have_content("Hello dummy@tamu.edu")

			sleep(0.5)
			click_on 'Click to sign up!'
			sleep(0.5)
			expect(page).to have_content("Successfully signed up for Test Event!")

			login_with_oauth

			visit edit_point_event_path(point_event)
			expect(page).to have_content("Force a user to attend the engagement")

			fill_in 'firstName', with: 'Bry'
			sleep(0.5)
			click_on 'Search for users'
			sleep(0.5)

			expect(page).to have_content("Force in")
			sleep(0.5)
			click_on 'Force in'
			sleep(0.5)
			expect(page).to have_content("Successfully")
		end

		it "is not possible if the user is already in the engagement" do
			visit sign_up_point_event_path(point_event)
			expect(page).to have_content("Engagement: Test Event")
			expect(page).to have_content("Hello bryalara@tamu.edu")

			sleep(0.5)
			click_on 'Click to sign up!'
			sleep(0.5)
			expect(page).to have_content("Successfully signed up for Test Event!")

			visit edit_point_event_path(point_event)
			expect(page).to have_content("Force a user to attend the engagement")

			fill_in 'firstName', with: 'Bry'
			sleep(0.5)
			click_on 'Search for users'
			sleep(0.5)

			expect(page).to have_content("Force in")
			sleep(0.5)
			click_on 'Force in'
			sleep(0.5)
			expect(page).to have_content("Successfully forced")

			fill_in 'firstName', with: 'Bry'
			sleep(0.5)
			click_on 'Search for users'
			sleep(0.5)

			expect(page).to have_content("Force in")
			sleep(0.5)
			click_on 'Force in'
			sleep(0.5)
			expect(page).to have_content("has already attended this")
		end

		it "is possible to force a user that is not approved" do
			user = User.create!(email: 'dummy@tamu.edu',
								role: 0,
								firstName: 'Feature',
								lastName: 'Testing',
								phoneNumber: '1231231234',
								tShirtSize: 'M',
								participationPoints: 5,
								classification: 'Senior',
								optInEmail: true,
								approved: false)
			visit edit_point_event_path(point_event)
			expect(page).to have_content("Force a user to attend the engagement")

			fill_in 'firstName', with: 'Fea'
			sleep(0.5)
			click_on 'Search for users'
			sleep(0.5)

			expect(page).to have_content("Force in")
			sleep(0.5)
			click_on 'Force in'
			sleep(0.5)

			expect(page).to have_content("Successfully")
		end
	end
end

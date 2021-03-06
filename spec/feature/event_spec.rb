require 'rails_helper'

RSpec.describe 'Events', type: :feature do
	setup do
		login_with_oauth
	end

	describe 'Routes for' do
		it 'index shows the right content' do
			visit event_index_path
			expect(page).to have_content('EVENTS')
		end

		it 'sign_up shows the right content' do
			event = Event.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						startDate: DateTime.now,
						endDate: DateTime.now + 1.week,
						capacity: 5)
			visit attend_event_path(id: event.id)
			expect(page).to have_content('TEST EVENT')
		end

		it 'qr shows the right content' do
			event = Event.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						startDate: DateTime.now, 	
						endDate: DateTime.now + 1.week,
						capacity: 5)
			visit qr_event_path(id: event.id)
			expect(page).to have_content('TEST EVENT')
		end
	
		it 'attend shows the right content' do
			event = Event.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						startDate: DateTime.now,
						endDate: DateTime.now + 1.week,
						capacity: 5)
			visit attend_event_path(id: event.id)
			expect(page).to have_content('TEST EVENT')
		end
	end

	describe 'Creating a new event' do
		setup do
			visit new_event_path
			fill_in 'event_name', with: 'Test Event'
			fill_in 'event_description', with: 'Test Description'
			fill_in 'event_points', with: 5
			fill_in 'event_startDate', with: DateTime.now
			fill_in 'event_endDate', with: DateTime.now + 1.week
			fill_in 'event_capacity', with: 5
		end

		it 'is valid with valid inputs' do
			click_on 'Add Event'
			visit event_index_path
			expect(page).to have_content('Test Event')
		end

		it 'is valid without a description' do
			fill_in 'event_description', with: ''
			click_on 'Add Event'
			visit event_index_path
			expect(page).to have_content('Test Event')
		end

		it 'is not valid without a name' do
			fill_in 'event_name', with: ''
			click_on 'Add Event'
			visit event_index_path
			expect(page).to_not have_content('Test Description')
		end

		it 'is not valid without points' do
			fill_in 'event_points', with: ""
			click_on 'Add Event'
			visit event_index_path
			expect(page).to_not have_content('Test Event')
		end

		it 'is valid with 0 points' do
			fill_in 'event_points', with: 0
			click_on 'Add Event'
			visit event_index_path
			expect(page).to have_content('Test Event')
		end

		it 'is not valid with negative points' do
			fill_in 'event_points', with: -1
			click_on 'Add Event'
			visit event_index_path
			expect(page).to_not have_content('Test Event')
		end

		it 'is not valid without a start date' do
			fill_in 'event_startDate', with: ''
			click_on 'Add Event'
			visit event_index_path
			expect(page).to_not have_content('Test Event')
		end

		it 'is not valid without an end date' do
			fill_in 'event_endDate', with: ''
			click_on 'Add Event'
			visit event_index_path
			expect(page).to_not have_content('Test Event')
		end

		it 'is not valid if the end date is before the start date' do
			fill_in 'event_endDate', with: DateTime.now - 1.week
			click_on 'Add Event'
			visit event_index_path
			expect(page).to_not have_content('Test Event')
		end

		it 'is valid with a capacity of 0' do
			fill_in 'event_capacity', with: 0
			click_on 'Add Event'
			visit event_index_path
			expect(page).to have_content('Test Event')
		end

		it 'is not valid with a negative capacity' do
			fill_in 'event_capacity', with: -1
			click_on 'Add Event'
			visit event_index_path
			expect(page).to_not have_content('Test Event')
		end

		it 'is not valid without a capacity' do
			fill_in 'event_capacity', with: ""
			click_on 'Add Event'
			visit event_index_path
			expect(page).to_not have_content('Test Event')
		end
	end

	describe 'Reading an existing event' do
		it 'reads events correctly' do
			event = Event.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						startDate: DateTime.now,
						endDate: DateTime.now + 1.week,
						capacity: 4)
			visit event_path(id: event.id)
			expect(page).to have_content('Test Event')
			expect(page).to have_content('Test Description')
			expect(page).to have_content('5')
			expect(page).to have_content(Event.display_date_time(event.startDate))
			expect(page).to have_content(Event.display_date_time(event.endDate))
			expect(page).to have_content('4')
		end
	end

	describe 'Updating an event' do

		setup do
			event = Event.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						startDate: DateTime.now,
						endDate: DateTime.now + 1.week,
						capacity: 5)
			visit edit_event_path(id: event.id)
			expect(page).to have_content("Edit An Event")
		end

		it 'is valid with valid changes' do
			fill_in 'event_name', with: "Edited Event Name"
			click_on 'Save Changes'
			visit event_index_path
			expect(page).to have_content('Edited Event Name')
		end

		it 'is valid with the description deleted' do
			fill_in 'event_name', with: "Edited Event Name"
			fill_in 'event_description', with: ""
			click_on 'Save Changes'
			visit event_index_path
			expect(page).to have_content('Edited Event Name')
		end

		it 'is not valid without a name' do
			fill_in 'event_name', with: ""
			fill_in 'event_description', with: "Edited Test Description"
			click_on 'Save Changes'
			visit event_index_path
			expect(page).to_not have_content('Edited Test Description')
		end

		it 'is not valid without points' do
			fill_in 'event_points', with: ""
			fill_in 'event_description', with: "Edited Test Description"
			click_on 'Save Changes'
			visit event_index_path
			expect(page).to_not have_content('Edited Test Description')
		end

		it 'is valid with 0 points' do
			fill_in 'event_points', with: 0
			fill_in 'event_description', with: "Edited Test Description"
			click_on 'Save Changes'
			visit event_index_path
			expect(page).to have_content('Edited Test Description')
		end

		it 'is not valid with negative points' do
			fill_in 'event_points', with: -5
			fill_in 'event_description', with: "Edited Test Description"
			click_on 'Save Changes'
			visit event_index_path
			expect(page).to_not have_content('Edited Test Description')
		end

		it 'is not valid without a start date' do
			fill_in 'event_startDate', with: ""
			fill_in 'event_description', with: "Edited Test Description"
			click_on 'Save Changes'
			visit event_index_path
			expect(page).to_not have_content('Edited Test Description')
		end

		it 'is not valid without an end date' do
			fill_in 'event_endDate', with: ""
			fill_in 'event_description', with: "Edited Test Description"
			click_on 'Save Changes'
			visit event_index_path
			expect(page).to_not have_content('Edited Test Description')
		end

		it 'is not valid if the end date is before the start date' do
			fill_in 'event_endDate', with: DateTime.now - 1.week
			fill_in 'event_description', with: "Edited Test Description"
			click_on 'Save Changes'
			visit event_index_path
			expect(page).to_not have_content('Edited Test Description')
		end

		it 'is valid with a capacity of 0' do
			fill_in 'event_capacity', with: 0
			fill_in 'event_description', with: "Edited Test Description"
			click_on 'Save Changes'
			visit event_index_path
			expect(page).to have_content('Edited Test Description')
		end

		it 'is not valid with a negative capacity' do
			fill_in 'event_capacity', with: -1
			fill_in 'event_description', with: "Edited Test Description"
			click_on 'Save Changes'
			visit event_index_path
			expect(page).to_not have_content('Edited Test Description')
		end

		it 'is not valid without a capacity' do
			fill_in 'event_capacity', with: ""
			fill_in 'event_description', with: "Edited Test Description"
			click_on 'Save Changes'
			visit event_index_path
			expect(page).to_not have_content('Edited Test Description')
		end
	end

	describe 'Deleting an event' do
		it 'succeeded in deleting event' do
			event = Event.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						startDate: DateTime.now,
						endDate: DateTime.now + 1.week,
						capacity: 5)
			visit event_index_path
			expect(page).to have_content('Test Event')

			visit delete_event_path(id: event.id)
			expect(page).to have_content('Test Event')
			sleep(0.5)
			click_on 'delete-btn'
			sleep(0.5)

			wait = Selenium::WebDriver::Wait.new ignore: Selenium::WebDriver::Error::NoSuchAlertError
			alert = wait.until { page.driver.browser.switch_to.alert }
			alert.accept

			expect(page).to have_content('Successfully deleted')
		end

		it 'succeeded in deleting three events' do
			event1 = Event.create!(name: 'Test Event 1',
						description: 'Test Description 1',
						points: 5,
						startDate: DateTime.now,
						endDate: DateTime.now + 1.week,
						capacity: 5)
			event2 = Event.create!(name: 'Test Event 2',
						description: 'Test Description 2',
						points: 5,
						startDate: DateTime.now,
						endDate: DateTime.now + 1.week,
						capacity: 5)
			event3 = Event.create!(name: 'Test Event 3',
						description: 'Test Description 3',
						points: 5,
						startDate: DateTime.now,
						endDate: DateTime.now + 1.week,
						capacity: 5)

			visit event_index_path
			expect(page).to have_content('Test Event 1')
			expect(page).to have_content('Test Event 2')
			expect(page).to have_content('Test Event 3')

			visit delete_event_path(id: event2.id)
			expect(page).to have_content('Test Event 2')
			sleep(0.5)
			click_on 'delete-btn'
			sleep(0.5)

			wait = Selenium::WebDriver::Wait.new ignore: Selenium::WebDriver::Error::NoSuchAlertError
			alert1 = wait.until { page.driver.browser.switch_to.alert }
			alert1.accept

			expect(page).to have_content('Test Event 1')
			expect(page).to have_content('Successfully deleted Test Event 2')
			expect(page).to have_content('Test Event 3')

			visit delete_event_path(id: event1.id)
			expect(page).to have_content('Test Event 1')
			sleep(0.5)
			click_on 'delete-btn'
			sleep(0.5)

			alert2 = wait.until { page.driver.browser.switch_to.alert }
			alert2.accept

			expect(page).to have_content('Successfully deleted Test Event 1')
			expect(page).to_not have_content('Test Event 2')
			expect(page).to have_content('Test Event 3')

			visit delete_event_path(id: event3.id)
			expect(page).to have_content('Test Event 3')
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

	describe "Removing a user from an event" do
		it "succeeded in removing a user from an event" do
			event = Event.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						startDate: DateTime.now,
						endDate: DateTime.now + 1.week,
						capacity: 5)

			visit sign_up_event_path(event)
			expect(page).to have_content('TEST EVENT')
			expect(page).to have_content('Registered User: Bryan Lara')

			click_link 'Sign Up'
			expect(page).to have_content("Successfully signed up for Test Event!")

			visit attend_event_path(event)
			expect(page).to have_content('TEST EVENT')
			expect(page).to have_content('Registered User: Bryan Lara')

			click_link 'Attend'
			sleep(1)
			expect(page).to have_content("Successfully attended Test Event!")

			visit edit_event_path(event)
			sleep(1)
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

	describe "When viewing events on the calendar" do
		it "an event from this month is visible" do
			event = Event.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						startDate: DateTime.now,
						endDate: DateTime.now + 1.hour,
						capacity: 5)

			visit event_index_path
			expect(page).to have_content(event.startDate.strftime("%B %Y"))
			expect(page).to have_content(event.startDate.strftime("%d %b"))

			within first(".simple-calendar") do
				click_on 'Test Event'
			end

			expect(page).to have_content("Test Event")
		end

		it "an event from the next month is visible" do
			event = Event.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						startDate: DateTime.now + 1.month,
						endDate: DateTime.now + 1.month + 1.hour,
						capacity: 5)

			visit event_index_path

			lastMonthDate = DateTime.now
			expect(page).to have_content(lastMonthDate.strftime("%B %Y"))

			click_on 'Next'

			expect(page).to have_content(event.startDate.strftime("%B %Y"))
			expect(page).to have_content(event.startDate.strftime("%d %b"))

			within first(".simple-calendar") do
				click_on 'Test Event'
			end

			expect(page).to have_content("Test Event")
		end
	end

	describe "When signing up for an event" do
		event = Event.new
		setup do
			event = Event.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						startDate: DateTime.now + 1.month,
						endDate: DateTime.now + 1.month + 1.hour,
						capacity: 2)
		end

		it "will allow registered and approved users to sign up" do
			visit sign_up_event_path(event)
			expect(page).to have_content('TEST EVENT')
			expect(page).to have_content('Registered User: Bryan Lara')

			click_link 'Sign Up'
			expect(page).to have_content("Successfully signed up for Test Event!")
		end

		it "shows the correct amount of users that have signed up" do
			visit event_index_path
			expect(page).to have_content("0 / 2")

			visit sign_up_event_path(event)
			expect(page).to have_content('TEST EVENT')
			expect(page).to have_content('Registered User: Bryan Lara')

			click_link 'Sign Up'
			expect(page).to have_content("Successfully signed up for Test Event!")

			visit event_index_path
			expect(page).to have_content("1 / 2")
		end

		it "shows the users that have signed up" do
			visit event_index_path
			expect(page).to have_content("0 / 2")

			visit event_path(event)
			expect(page).to_not have_content("bryalara@tamu.edu")

			visit sign_up_event_path(event)
			expect(page).to have_content('TEST EVENT')
			expect(page).to have_content('Registered User: Bryan Lara')

			click_link 'Sign Up'
			expect(page).to have_content("Successfully signed up for Test Event!")

			visit event_index_path
			expect(page).to have_content("1 / 2")

			visit event_path(event)
			expect(page).to have_content("bryalara@tamu.edu")
			expect(page).to have_content("N/A")
		end

		it "will notify users have already signed up if they try to sign up twice" do
			visit sign_up_event_path(event)
			expect(page).to have_content('TEST EVENT')
			expect(page).to have_content('Registered User: Bryan Lara')

			click_link 'Sign Up'
			expect(page).to have_content("Successfully signed up for Test Event!")

			visit sign_up_event_path(event)
			expect(page).to have_content('TEST EVENT')
			expect(page).to have_content('Registered User: Bryan Lara')
			
			click_link 'Sign Up'
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

			visit sign_up_event_path(event)
			expect(page).to have_content('TEST EVENT')
			expect(page).to have_content('Registered User: Feature Testing')

			click_link 'Sign Up'
			expect(page).to have_content("Successfully signed up for Test Event!")
		end

		it "will not allow unregistered users to sign up" do
			login_with_oauth_as("Feature Testing", "dummy@tamu.edu")
			visit sign_up_event_path(event)

			expect(page).to_not have_content("Test Event")
		end

		it "will not allow users to sign up if it is full" do
			visit sign_up_event_path(event)
			expect(page).to have_content('TEST EVENT')
			expect(page).to have_content('Registered User: Bryan Lara')

			click_link 'Sign Up'
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
			visit sign_up_event_path(event)
			expect(page).to have_content('TEST EVENT')
			expect(page).to have_content('Registered User: Feature Testing')

			click_link 'Sign Up'
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
			visit sign_up_event_path(event)
			expect(page).to have_content('TEST EVENT')
			expect(page).to have_content('Registered User: Feature Testing')

			click_link 'Sign Up'
			expect(page).to have_content("Cannot sign up for Test Event! The event has reached its capacity.")
		end

		it "will allow users to sign up if the capacity is 0" do
			event.capacity = 0
			event.save

			visit sign_up_event_path(event)
			expect(page).to have_content('TEST EVENT')
			expect(page).to have_content('Registered User: Bryan Lara')

			click_link 'Sign Up'
			expect(page).to have_content("Successfully signed up for Test Event!")
		end
	end

	describe "When attending an event" do
		event = Event.new

		setup do
			event = Event.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						startDate: DateTime.now + 1.month,
						endDate: DateTime.now + 1.month + 1.hour,
						capacity: 2)
		end

		it "will not allow users that have not signed up to attend" do
			visit attend_event_path(event)
			expect(page).to have_content('TEST EVENT')
			expect(page).to have_content('Registered User: Bryan Lara')

			click_link 'Attend'
			expect(page).to have_content("Could not attend Test Event because you did not sign up for the event.")
		end

		it "will allow registered and approved users that have signed up to attend" do
			visit sign_up_event_path(event)
			expect(page).to have_content('TEST EVENT')
			expect(page).to have_content('Registered User: Bryan Lara')

			click_link 'Sign Up'
			expect(page).to have_content("Successfully signed up for Test Event!")

			visit attend_event_path(event)
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

			visit sign_up_event_path(event)
			expect(page).to have_content('TEST EVENT')
			expect(page).to have_content('Registered User: Feature Testing')

			click_link 'Sign Up'
			expect(page).to have_content("Successfully signed up for Test Event!")

			visit attend_event_path(event)
			expect(page).to have_content('TEST EVENT')
			expect(page).to have_content('Registered User: Feature Testing')

			click_link 'Attend'
			expect(page).to have_content("Successfully attended Test Event!")
		end

		it "will not allow unregistered users to attend" do
			login_with_oauth_as("Feature Testing", "dummy@tamu.edu")
			visit attend_event_path(event)
			expect(page).to have_content("REGISTRATION")
		end

		describe "with a capacity of 0" do
			it "will allow users who have not signed up for it to attend" do
				event.capacity = 0
				event.save

				visit attend_event_path(event)
				expect(page).to have_content("TEST EVENT")
				expect(page).to have_content("Registered User: Bryan Lara")
	
				click_link 'Attend'
				expect(page).to have_content("Successfully attended Test Event!")
			end
		end
	end

	describe "When forcing users into an event" do
		event = Event.new
		setup do
			event = Event.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						startDate: DateTime.now + 1.month,
						endDate: DateTime.now + 1.month + 1.hour,
						capacity: 1)
		end

		it "is possible when the user has not signed up for it" do
			visit edit_event_path(event)
			expect(page).to have_content("Force User Attendance")

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
			visit sign_up_event_path(event)
			expect(page).to have_content('TEST EVENT')
			expect(page).to have_content('Registered User: Bryan Lara')
			sleep(0.5)
			click_link 'Sign Up'
			sleep(0.5)
			expect(page).to have_content("Successfully signed up for Test Event!")

			visit edit_event_path(event)
			expect(page).to have_content("Force User Attendance")

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

		it "is possible even when the event is full" do
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

			visit sign_up_event_path(event)
			expect(page).to have_content('TEST EVENT')
			expect(page).to have_content('Registered User: Feature Testing')

			sleep(0.5)
			click_link 'Sign Up'
			sleep(0.5)
			expect(page).to have_content("Successfully signed up for Test Event!")

			login_with_oauth

			visit edit_event_path(event)
			expect(page).to have_content("Force User Attendance")

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

		it "is not possible if the user is already in the event" do
			visit sign_up_event_path(event)
			expect(page).to have_content('TEST EVENT')
			expect(page).to have_content('Registered User: Bryan Lara')

			sleep(0.5)
			click_link 'Sign Up'
			sleep(0.5)
			expect(page).to have_content("Successfully signed up for Test Event!")

			visit edit_event_path(event)
			expect(page).to have_content("Force User Attendance")

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
			visit edit_event_path(event)
			expect(page).to have_content("Force User Attendance")

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

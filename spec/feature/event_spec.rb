require 'rails_helper'

RSpec.describe 'Events', type: :feature do
	setup do
		login_with_oauth
	end

	# describe 'Routes for' do
	# 	it 'index shows the right content' do
	# 		visit event_index_path
	# 		sleep(3)
	# 		# page.should have_xpath('//div.header2/h2')
	# 		# expect(page).to have_content('Events').first
	# 		expect(page).to have_selector(:xpath, "//div/h2['Events']")
	# 		# expect(page).to have_xpath('/html/body/div[2]/h2')
			
	# 	end

	# 	it 'qr shows the right content' do
	# 		event = Event.create!(name: 'Test Event',
	# 					description: 'Test Description',
	# 					points: 5,
	# 					startDate: DateTime.now, 	
	# 					endDate: DateTime.now + 1.week)
	# 		visit qr_event_path(id: event.id)
	# 		expect(page).to have_content('Test Event')
	# 	end
	
	# 	it 'attend shows the right content' do
	# 		event = Event.create!(name: 'Test Event',
	# 					description: 'Test Description',
	# 					points: 5,
	# 					startDate: DateTime.now,
	# 					endDate: DateTime.now + 1.week)
	# 		visit attend_event_path(id: event.id)
	# 		expect(page).to have_content('Test Event')
	# 	end
	# end

	# describe 'Creating a new event' do
	# 	setup do
	# 		visit new_event_path
	# 		fill_in 'event_name', with: 'Test Event'
	# 		fill_in 'event_description', with: 'Test Description'
	# 		fill_in 'event_points', with: 5
	# 		fill_in 'event_startDate', with: DateTime.now
	# 		fill_in 'event_endDate', with: DateTime.now + 1.week
	# 	end

	# 	it 'is valid with valid inputs' do
	# 		click_on 'Add Event'
	# 		visit event_index_path
	# 		expect(page).to have_content('Test Event')
	# 	end

	# 	it 'is valid without a description' do
	# 		fill_in 'event_description', with: ''
	# 		click_on 'Add Event'
	# 		visit event_index_path
	# 		expect(page).to have_content('Test Event')
	# 	end

	# 	it 'is not valid without a name' do
	# 		fill_in 'event_name', with: ''
	# 		click_on 'Add Event'
	# 		visit event_index_path
	# 		expect(page).to_not have_content('Test Description')
	# 	end

	# 	it 'is not valid without points' do
	# 		fill_in 'event_points', with: nil
	# 		click_on 'Add Event'
	# 		visit event_index_path
	# 		expect(page).to_not have_content('Test Event')
	# 	end

	# 	it 'is valid with 0 points' do
	# 		fill_in 'event_points', with: 0
	# 		click_on 'Add Event'
	# 		visit event_index_path
	# 		expect(page).to have_content('Test Event')
	# 	end

	# 	it 'is not valid with negative points' do
	# 		fill_in 'event_points', with: -1
	# 		click_on 'Add Event'
	# 		visit event_index_path
	# 		expect(page).to_not have_content('Test Event')
	# 	end

	# 	it 'is not valid without a start date' do
	# 		fill_in 'event_startDate', with: ''
	# 		click_on 'Add Event'
	# 		visit event_index_path
	# 		expect(page).to_not have_content('Test Event')
	# 	end

	# 	it 'is not valid without an end date' do
	# 		fill_in 'event_endDate', with: ''
	# 		click_on 'Add Event'
	# 		visit event_index_path
	# 		expect(page).to_not have_content('Test Event')
	# 	end

	# 	it 'is not valid if the end date is before the start date' do
	# 		fill_in 'event_endDate', with: DateTime.now - 1.week
	# 		click_on 'Add Event'
	# 		visit event_index_path
	# 		expect(page).to_not have_content('Test Event')
	# 	end
	# end

	# describe 'Reading an existing event' do
	# 	it 'reads events correctly' do
	# 		event = Event.create!(name: 'Test Event',
	# 					description: 'Test Description',
	# 					points: 5,
	# 					startDate: DateTime.now,
	# 					endDate: DateTime.now + 1.week)
	# 		visit event_path(id: event.id)
	# 		expect(page).to have_content('Test Event')
	# 		expect(page).to have_content('Test Description')
	# 		expect(page).to have_content('5')
	# 		expect(page).to have_content(Event.dateTimeDisplay(event.startDate))
	# 		expect(page).to have_content(Event.dateTimeDisplay(event.endDate))
	# 	end
	# end

	# describe 'Updating an event' do

	# 	setup do
	# 		event = Event.create!(name: 'Test Event',
	# 					description: 'Test Description',
	# 					points: 5,
	# 					startDate: DateTime.now,
	# 					endDate: DateTime.now + 1.week)
	# 		visit edit_event_path(id: event.id)
	# 	end

	# 	it 'is valid with valid changes' do
	# 		fill_in 'event_name', with: "Edited Event Name"
	# 		click_on 'Save Changes to Event'
	# 		visit event_index_path
	# 		expect(page).to have_content('Edited Event Name')
	# 	end

	# 	it 'is valid with the description deleted' do
	# 		fill_in 'event_name', with: "Edited Event Name"
	# 		fill_in 'event_description', with: ""
	# 		click_on 'Save Changes to Event'
	# 		visit event_index_path
	# 		expect(page).to have_content('Edited Event Name')
	# 	end

	# 	it 'is not valid without a name' do
	# 		fill_in 'event_name', with: ""
	# 		fill_in 'event_description', with: "Edited Test Description"
	# 		click_on 'Save Changes to Event'
	# 		visit event_index_path
	# 		expect(page).to_not have_content('Edited Test Description')
	# 	end

	# 	it 'is not valid without points' do
	# 		fill_in 'event_points', with: ""
	# 		fill_in 'event_description', with: "Edited Test Description"
	# 		click_on 'Save Changes to Event'
	# 		visit event_index_path
	# 		expect(page).to_not have_content('Edited Test Description')
	# 	end

	# 	it 'is valid with 0 points' do
	# 		fill_in 'event_points', with: 0
	# 		fill_in 'event_description', with: "Edited Test Description"
	# 		click_on 'Save Changes to Event'
	# 		visit event_index_path
	# 		expect(page).to have_content('Edited Test Description')
	# 	end

	# 	it 'is not valid with negative points' do
	# 		fill_in 'event_points', with: -5
	# 		fill_in 'event_description', with: "Edited Test Description"
	# 		click_on 'Save Changes to Event'
	# 		visit event_index_path
	# 		expect(page).to_not have_content('Edited Test Description')
	# 	end

	# 	it 'is not valid without a start date' do
	# 		fill_in 'event_startDate', with: ""
	# 		fill_in 'event_description', with: "Edited Test Description"
	# 		click_on 'Save Changes to Event'
	# 		visit event_index_path
	# 		expect(page).to_not have_content('Edited Test Description')
	# 	end

	# 	it 'is not valid without an end date' do
	# 		fill_in 'event_endDate', with: ""
	# 		fill_in 'event_description', with: "Edited Test Description"
	# 		click_on 'Save Changes to Event'
	# 		visit event_index_path
	# 		expect(page).to_not have_content('Edited Test Description')
	# 	end

	# 	it 'is not valid if the end date is before the start date' do
	# 		fill_in 'event_endDate', with: DateTime.now - 1.week
	# 		fill_in 'event_description', with: "Edited Test Description"
	# 		click_on 'Save Changes to Event'
	# 		visit event_index_path
	# 		expect(page).to_not have_content('Edited Test Description')
	# 	end
	# end

	describe 'Deleting an event' do
		it 'succeeded in deleting event' do
			event = Event.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						startDate: DateTime.now,
						endDate: DateTime.now + 1.week)
			visit event_index_path
			expect(page).to have_content('Test Event')

			visit delete_event_path(id: event.id)
			expect(page).to have_content('Test Event')
			click_on 'delete-btn'

			# wait = Selenium::WebDriver::Wait.new ignore: Selenium::WebDriver::Error::NoSuchAlertError
			# alert = wait.until { page.driver.browser.switch_to.alert }
			# alert.accept
			# sleep(5)
			# page.driver.browser.switch_to.alert.accept

			expect(page).to have_content('Successfully deleted')
		end

		it 'succeeded in deleting three events' do
			event1 = Event.create!(name: 'Test Event 1',
						description: 'Test Description 1',
						points: 5,
						startDate: DateTime.now,
						endDate: DateTime.now + 1.week)
			event2 = Event.create!(name: 'Test Event 2',
						description: 'Test Description 2',
						points: 5,
						startDate: DateTime.now,
						endDate: DateTime.now + 1.week)
			event3 = Event.create!(name: 'Test Event 3',
						description: 'Test Description 3',
						points: 5,
						startDate: DateTime.now,
						endDate: DateTime.now + 1.week)

			visit event_index_path
			expect(page).to have_content('Test Event 1')
			expect(page).to have_content('Test Event 2')
			expect(page).to have_content('Test Event 3')

			visit delete_event_path(id: event2.id)
			expect(page).to have_content('Test Event 2')
			click_on 'delete-btn'
			wait = Selenium::WebDriver::Wait.new ignore: Selenium::WebDriver::Error::NoSuchAlertError
			alert1 = wait.until { page.driver.browser.switch_to.alert }
			alert1.accept

			expect(page).to have_content('Test Event 1')
			expect(page).to have_content('Successfully deleted Test Event 2')
			expect(page).to have_content('Test Event 3')

			visit delete_event_path(id: event1.id)
			expect(page).to have_content('Test Event 1')
			click_on 'delete-btn'
			alert2 = wait.until { page.driver.browser.switch_to.alert }
			alert2.accept

			expect(page).to have_content('Successfully deleted Test Event 1')
			expect(page).to_not have_content('Test Event 2')
			expect(page).to have_content('Test Event 3')

			visit delete_event_path(id: event3.id)
			expect(page).to have_content('Test Event 3')
			click_on 'delete-btn'
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
						endDate: DateTime.now + 1.week)

			visit attend_event_path(event)
			expect(page).to have_content('Test Event')
			expect(page).to have_content('Hello bryalara@tamu.edu')

			click_on 'Click to attend!'
			expect(page).to have_content("Successfully attended Test Event!")

			visit edit_event_path(event)
			expect(page).to have_content('bryalara@tamu.edu')

			click_on 'Remove'
			wait = Selenium::WebDriver::Wait.new ignore: Selenium::WebDriver::Error::NoSuchAlertError
			alert = wait.until { page.driver.browser.switch_to.alert }
			alert.accept

			expect(page).to_not have_content('bryalara@tamu.edu')
		end
	end
end

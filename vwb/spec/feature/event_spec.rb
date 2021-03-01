require 'rails_helper'

RSpec.describe 'Events', type: :feature do

	setup do
		login_with_oauth
	end

	describe 'index page' do
		it 'shows the right content' do
			visit event_index_path
			expect(page).to have_content('Events')
		end
	end

	describe 'Creating a new event' do
		it 'is valid with valid inputs' do
			visit new_event_path
			fill_in 'event_name', with: 'Test Event'
			fill_in 'event_description', with: 'Test Description'
			fill_in 'event_points', with: 5
			fill_in 'event_eventType', with: 'Test Type'
			select '2021', :from => 'event_startDate_1i'
			select 'February', :from => 'event_startDate_2i'
			select '24', :from => 'event_startDate_3i'
			select '12 PM', :from => 'event_startDate_4i'
			select '00', :from => 'event_startDate_5i'
			select '2021', :from => 'event_endDate_1i'
			select 'February', :from => 'event_endDate_2i'
			select '24', :from => 'event_endDate_3i'
			select '01 PM', :from => 'event_endDate_4i'
			select '00', :from => 'event_endDate_5i'
			click_on 'Add Event'
			visit event_index_path
			expect(page).to have_content('Test Event')
		end

		it 'is valid without a description' do
			visit new_event_path
			fill_in 'event_name', with: 'Test Event'
			fill_in 'event_points', with: 5
			fill_in 'event_eventType', with: 'Test Type'
			select '2021', :from => 'event_startDate_1i'
			select 'February', :from => 'event_startDate_2i'
			select '24', :from => 'event_startDate_3i'
			select '12 PM', :from => 'event_startDate_4i'
			select '00', :from => 'event_startDate_5i'
			select '2021', :from => 'event_endDate_1i'
			select 'February', :from => 'event_endDate_2i'
			select '24', :from => 'event_endDate_3i'
			select '01 PM', :from => 'event_endDate_4i'
			select '00', :from => 'event_endDate_5i'
			click_on 'Add Event'
			visit event_index_path
			expect(page).to have_content('Test Event')
		end

		it 'is not valid without a name' do
			visit new_event_path
			fill_in 'event_description', with: 'Test Description'
			fill_in 'event_points', with: 5
			fill_in 'event_eventType', with: 'Test Type'
			select '2021', :from => 'event_startDate_1i'
			select 'February', :from => 'event_startDate_2i'
			select '24', :from => 'event_startDate_3i'
			select '12 PM', :from => 'event_startDate_4i'
			select '00', :from => 'event_startDate_5i'
			select '2021', :from => 'event_endDate_1i'
			select 'February', :from => 'event_endDate_2i'
			select '24', :from => 'event_endDate_3i'
			select '01 PM', :from => 'event_endDate_4i'
			select '00', :from => 'event_endDate_5i'
			click_on 'Add Event'
			visit event_index_path
			expect(page).to_not have_content('Test Description')
		end

		it 'is not valid without points' do
			visit new_event_path
			fill_in 'event_name', with: 'Test Event'
			fill_in 'event_description', with: 'Test Description'
			fill_in 'event_eventType', with: 'Test Type'
			select '2021', :from => 'event_startDate_1i'
			select 'February', :from => 'event_startDate_2i'
			select '24', :from => 'event_startDate_3i'
			select '12 PM', :from => 'event_startDate_4i'
			select '00', :from => 'event_startDate_5i'
			select '2021', :from => 'event_endDate_1i'
			select 'February', :from => 'event_endDate_2i'
			select '24', :from => 'event_endDate_3i'
			select '01 PM', :from => 'event_endDate_4i'
			select '00', :from => 'event_endDate_5i'
			click_on 'Add Event'
			visit event_index_path
			expect(page).to_not have_content('Test Event')
		end

		it 'is valid with 0 points' do
			visit new_event_path
			fill_in 'event_name', with: 'Test Event'
			fill_in 'event_description', with: 'Test Description'
			fill_in 'event_points', with: 0
			fill_in 'event_eventType', with: 'Test Type'
			select '2021', :from => 'event_startDate_1i'
			select 'February', :from => 'event_startDate_2i'
			select '24', :from => 'event_startDate_3i'
			select '12 PM', :from => 'event_startDate_4i'
			select '00', :from => 'event_startDate_5i'
			select '2021', :from => 'event_endDate_1i'
			select 'February', :from => 'event_endDate_2i'
			select '24', :from => 'event_endDate_3i'
			select '01 PM', :from => 'event_endDate_4i'
			select '00', :from => 'event_endDate_5i'
			click_on 'Add Event'
			visit event_index_path
			expect(page).to have_content('Test Event')
		end

		it 'is not valid with negative points' do
			visit new_event_path
			fill_in 'event_name', with: 'Test Event'
			fill_in 'event_description', with: 'Test Description'
			fill_in 'event_points', with: -1
			fill_in 'event_eventType', with: 'Test Type'
			select '2021', :from => 'event_startDate_1i'
			select 'February', :from => 'event_startDate_2i'
			select '24', :from => 'event_startDate_3i'
			select '12 PM', :from => 'event_startDate_4i'
			select '00', :from => 'event_startDate_5i'
			select '2021', :from => 'event_endDate_1i'
			select 'February', :from => 'event_endDate_2i'
			select '24', :from => 'event_endDate_3i'
			select '01 PM', :from => 'event_endDate_4i'
			select '00', :from => 'event_endDate_5i'
			click_on 'Add Event'
			visit event_index_path
			expect(page).to_not have_content('Test Event')
		end

		it 'is not valid without a start date' do
			visit new_event_path
			fill_in 'event_name', with: 'Test Event'
			fill_in 'event_description', with: 'Test Description'
			fill_in 'event_points', with: 5
			fill_in 'event_eventType', with: 'Test Type'
			select '2021', :from => 'event_endDate_1i'
			select 'February', :from => 'event_endDate_2i'
			select '24', :from => 'event_endDate_3i'
			select '01 PM', :from => 'event_endDate_4i'
			select '00', :from => 'event_endDate_5i'
			click_on 'Add Event'
			visit event_index_path
			expect(page).to_not have_content('Test Event')
		end

		it 'is not valid without an end date' do
			visit new_event_path
			fill_in 'event_name', with: 'Test Event'
			fill_in 'event_description', with: 'Test Description'
			fill_in 'event_points', with: 5
			fill_in 'event_eventType', with: 'Test Type'
			select '2021', :from => 'event_startDate_1i'
			select 'February', :from => 'event_startDate_2i'
			select '24', :from => 'event_startDate_3i'
			select '12 PM', :from => 'event_startDate_4i'
			select '00', :from => 'event_startDate_5i'
			click_on 'Add Event'
			visit event_index_path
			expect(page).to_not have_content('Test Event')
		end

		it 'is not valid if the end date is before the start date' do
			visit new_event_path
			fill_in 'event_name', with: 'Test Event'
			fill_in 'event_description', with: 'Test Description'
			fill_in 'event_points', with: 5
			fill_in 'event_eventType', with: 'Test Type'
			select '2021', :from => 'event_startDate_1i'
			select 'February', :from => 'event_startDate_2i'
			select '24', :from => 'event_startDate_3i'
			select '12 PM', :from => 'event_startDate_4i'
			select '00', :from => 'event_startDate_5i'
			select '2021', :from => 'event_endDate_1i'
			select 'February', :from => 'event_endDate_2i'
			select '24', :from => 'event_endDate_3i'
			select '05 AM', :from => 'event_endDate_4i'
			select '00', :from => 'event_endDate_5i'
			click_on 'Add Event'
			visit event_index_path
			expect(page).to_not have_content('Test Event')
		end

		it 'is not valid without an event type' do
			visit new_event_path
			fill_in 'event_name', with: 'Test Event'
			fill_in 'event_description', with: 'Test Description'
			fill_in 'event_points', with: 5
			select '2021', :from => 'event_startDate_1i'
			select 'February', :from => 'event_startDate_2i'
			select '24', :from => 'event_startDate_3i'
			select '12 PM', :from => 'event_startDate_4i'
			select '00', :from => 'event_startDate_5i'
			select '2021', :from => 'event_endDate_1i'
			select 'February', :from => 'event_endDate_2i'
			select '24', :from => 'event_endDate_3i'
			select '01 PM', :from => 'event_endDate_4i'
			select '00', :from => 'event_endDate_5i'
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
						eventType: 'Test Type',
						startDate: DateTime.now,
						endDate: DateTime.now + 1.week)
			visit event_path(id: event.id)
			expect(page).to have_content('Test Event')
			expect(page).to have_content('Test Description')
			expect(page).to have_content('5')
			expect(page).to have_content('Test Type')
			expect(page).to have_content(Event.dateTimeDisplay(event.startDate))
			expect(page).to have_content(Event.dateTimeDisplay(event.endDate))
		end
	end

	describe 'Updating an event' do
		it 'is valid with valid changes' do
			event = Event.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						eventType: 'Test Type',
						startDate: DateTime.now,
						endDate: DateTime.now + 1.week)
			visit edit_event_path(id: event.id)
			fill_in 'event_name', with: "Edited Event Name"
			click_on 'Save Changes to Event'
			visit event_index_path
			expect(page).to have_content('Edited Event Name')
		end

		it 'is valid with the description deleted' do
			event = Event.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						eventType: 'Test Type',
						startDate: DateTime.now,
						endDate: DateTime.now + 1.week)
			visit edit_event_path(id: event.id)
			fill_in 'event_name', with: "Edited Event Name"
			fill_in 'event_description', with: ""
			click_on 'Save Changes to Event'
			visit event_index_path
			expect(page).to have_content('Edited Event Name')
		end

		it 'is not valid without a name' do
			event = Event.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						eventType: 'Test Type',
						startDate: DateTime.now,
						endDate: DateTime.now + 1.week)
			visit edit_event_path(id: event.id)
			fill_in 'event_name', with: ""
			fill_in 'event_description', with: "Edited Test Description"
			click_on 'Save Changes to Event'
			visit event_index_path
			expect(page).to_not have_content('Edited Test Description')
		end

		it 'is not valid without points' do
			event = Event.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						eventType: 'Test Type',
						startDate: DateTime.now,
						endDate: DateTime.now + 1.week)
			visit edit_event_path(id: event.id)
			fill_in 'event_points', with: ""
			fill_in 'event_description', with: "Edited Test Description"
			click_on 'Save Changes to Event'
			visit event_index_path
			expect(page).to_not have_content('Edited Test Description')
		end

		it 'is valid with 0 points' do
			event = Event.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						eventType: 'Test Type',
						startDate: DateTime.now,
						endDate: DateTime.now + 1.week)
			visit edit_event_path(id: event.id)
			fill_in 'event_points', with: 0
			fill_in 'event_description', with: "Edited Test Description"
			click_on 'Save Changes to Event'
			visit event_index_path
			expect(page).to have_content('Edited Test Description')
		end

		it 'is not valid with negative points' do
			event = Event.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						eventType: 'Test Type',
						startDate: DateTime.now,
						endDate: DateTime.now + 1.week)
			visit edit_event_path(id: event.id)
			fill_in 'event_points', with: -5
			fill_in 'event_description', with: "Edited Test Description"
			click_on 'Save Changes to Event'
			visit event_index_path
			expect(page).to_not have_content('Edited Test Description')
		end

		it 'is not valid without a start date' do
			event = Event.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						eventType: 'Test Type',
						startDate: DateTime.now,
						endDate: DateTime.now + 1.week)
			visit edit_event_path(id: event.id)
			select "Year", :from => 'event_startDate_1i'
			select "Month", :from => 'event_startDate_2i'
			select "Day", :from => 'event_startDate_3i'
			select "Hour", :from => 'event_startDate_4i'
			select "Min", :from => 'event_startDate_5i'
			fill_in 'event_description', with: "Edited Test Description"
			click_on 'Save Changes to Event'
			visit event_index_path
			expect(page).to_not have_content('Edited Test Description')
		end

		it 'is not valid without an end date' do
			event = Event.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						eventType: 'Test Type',
						startDate: DateTime.now,
						endDate: DateTime.now + 1.week)
			visit edit_event_path(id: event.id)
			select "Year", :from => 'event_endDate_1i'
			select "Month", :from => 'event_endDate_2i'
			select "Day", :from => 'event_endDate_3i'
			select "Hour", :from => 'event_endDate_4i'
			select "Min", :from => 'event_endDate_5i'
			fill_in 'event_description', with: "Edited Test Description"
			click_on 'Save Changes to Event'
			visit event_index_path
			expect(page).to_not have_content('Edited Test Description')
		end

		it 'is not valid if the end date is before the start date' do
			event = Event.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						eventType: 'Test Type',
						startDate: DateTime.now,
						endDate: DateTime.now + 1.week)

			futureDate = event.startDate + 2.week

			visit edit_event_path(id: event.id)
			select futureDate.strftime("%Y"), :from => 'event_startDate_1i'
			select futureDate.strftime("%B"), :from => 'event_startDate_2i'
			select futureDate.strftime("%d"), :from => 'event_startDate_3i'
			select futureDate.strftime("%I %p"), :from => 'event_startDate_4i'
			select futureDate.strftime("%M"), :from => 'event_startDate_5i'
			fill_in 'event_description', with: "Edited Test Description"
			click_on 'Save Changes to Event'
			visit event_index_path
			expect(page).to_not have_content('Edited Test Description')
		end

		it 'is not valid without an event type' do
			event = Event.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						eventType: 'Test Type',
						startDate: DateTime.now,
						endDate: DateTime.now + 1.week)
			visit edit_event_path(id: event.id)
			fill_in 'event_eventType', with: ""
			fill_in 'event_description', with: "Edited Test Description"
			click_on 'Save Changes to Event'
			visit event_index_path
			expect(page).to_not have_content('Edited Test Description')
		end
	end

	describe 'Deleting an event' do
		it 'succeeded in deleting event' do
			event = Event.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						eventType: 'Test Type',
						startDate: DateTime.now,
						endDate: DateTime.now + 1.week)
			visit event_index_path
			expect(page).to have_content('Test Event')

			visit delete_event_path(id: event.id)
			click_on 'Delete'
			sleep(1)

			a = page.driver.browser.switch_to.alert
			a.accept
			sleep(1)

			visit event_index_path
			expect(page).to_not have_content('Test Event')
		end

		it 'succeeded in deleting three events' do
			event1 = Event.create!(name: 'Test Event 1',
						description: 'Test Description 1',
						points: 5,
						eventType: 'Test Type 1',
						startDate: DateTime.now,
						endDate: DateTime.now + 1.week)
			event2 = Event.create!(name: 'Test Event 2',
						description: 'Test Description 2',
						points: 5,
						eventType: 'Test Type 2',
						startDate: DateTime.now,
						endDate: DateTime.now + 1.week)
			event3 = Event.create!(name: 'Test Event 3',
						description: 'Test Description 3',
						points: 5,
						eventType: 'Test Type 3',
						startDate: DateTime.now,
						endDate: DateTime.now + 1.week)

			visit event_index_path
			expect(page).to have_content('Test Event 1')
			expect(page).to have_content('Test Event 2')
			expect(page).to have_content('Test Event 3')

			visit delete_event_path(id: event2.id)
			click_on 'Delete'
			sleep(1)
			a = page.driver.browser.switch_to.alert
			a.accept
			sleep(1)

			visit event_index_path
			expect(page).to have_content('Test Event 1')
			expect(page).to_not have_content('Test Event 2')
			expect(page).to have_content('Test Event 3')

			visit delete_event_path(id: event1.id)
			click_on 'Delete'
			sleep(1)
			a2 = page.driver.browser.switch_to.alert
			a2.accept
			sleep(1)

			visit event_index_path
			expect(page).to_not have_content('Test Event 1')
			expect(page).to_not have_content('Test Event 2')
			expect(page).to have_content('Test Event 3')

			visit delete_event_path(id: event3.id)
			click_on 'Delete'
			sleep(1)
			a3 = page.driver.browser.switch_to.alert
			a3.accept
			sleep(1)

			visit event_index_path
			expect(page).to_not have_content('Test Event 1')
			expect(page).to_not have_content('Test Event 2')
			expect(page).to_not have_content('Test Event 3')
		end
	end
end

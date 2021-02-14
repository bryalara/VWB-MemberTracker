require 'rails_helper'

RSpec.describe 'Events', type: :feature do
	describe 'index page' do
		it 'shows the right content' do
			visit event_index_path
			#sleep(10)
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
			fill_in 'event_startDate', with: DateTime.now
			fill_in 'event_endDate', with: DateTime.now + 1.week
			click_on 'Add Event'
			visit event_index_path
			expect(page).to have_content('Test Event')
		end

		it 'is valid without a description' do
			visit new_event_path
			fill_in 'event_name', with: 'Test Event'
			fill_in 'event_points', with: 5
			fill_in 'event_eventType', with: 'Test Type'
			fill_in 'event_startDate', with: DateTime.now
			fill_in 'event_endDate', with: DateTime.now + 1.week
			click_on 'Add Event'
			visit event_index_path
			expect(page).to have_content('Test Event')
		end

		it 'is not valid without a name' do
			visit new_event_path
			fill_in 'event_description', with: 'Test Description'
			fill_in 'event_points', with: 5
			fill_in 'event_eventType', with: 'Test Type'
			fill_in 'event_startDate', with: DateTime.now
			fill_in 'event_endDate', with: DateTime.now + 1.week
			click_on 'Add Event'
			visit event_index_path
			expect(page).to_not have_content('Test Description')
		end

		it 'is not valid without points' do
			visit new_event_path
			fill_in 'event_name', with: 'Test Event'
			fill_in 'event_description', with: 'Test Description'
			fill_in 'event_eventType', with: 'Test Type'
			fill_in 'event_startDate', with: DateTime.now
			fill_in 'event_endDate', with: DateTime.now + 1.week
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
			fill_in 'event_startDate', with: DateTime.now
			fill_in 'event_endDate', with: DateTime.now + 1.week
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
			fill_in 'event_startDate', with: DateTime.now
			fill_in 'event_endDate', with: DateTime.now + 1.week
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
			fill_in 'event_endDate', with: DateTime.now + 1.week
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
			fill_in 'event_startDate', with: DateTime.now
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
			fill_in 'event_startDate', with: DateTime.now
			fill_in 'event_endDate', with: DateTime.now - 1.week
			click_on 'Add Event'
			visit event_index_path
			expect(page).to_not have_content('Test Event')
		end

		it 'is not valid without an event type' do
			visit new_event_path
			fill_in 'event_name', with: 'Test Event'
			fill_in 'event_description', with: 'Test Description'
			fill_in 'event_points', with: 5
			fill_in 'event_startDate', with: DateTime.now
			fill_in 'event_endDate', with: DateTime.now + 1.week
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
			expect(page).to have_content(event.startDate)
			expect(page).to have_content(event.endDate)
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
			fill_in 'event_startDate', with: nil
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
			fill_in 'event_endDate', with: nil
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
			visit edit_event_path(id: event.id)
			fill_in 'event_endDate', with: DateTime.now - 1.week
			fill_in 'event_description', with: "Edited Test Description"
			click_on 'Save Changes to Event'
			visit event_index_path
			expect(page).to_not have_content('Edited Test Description')
		end

		it 'is not valid without an event Type' do
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

			visit event_index_path
			expect(page).to_not have_content('Test Event')
		end
	end
end

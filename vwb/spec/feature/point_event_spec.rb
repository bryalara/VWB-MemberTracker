require 'rails_helper'

RSpec.describe 'PointEvents', type: :feature do
	describe 'index page' do
		it 'shows the right content' do
			visit point_event_index_path
			#sleep(10)
			expect(page).to have_content('Points Events')
		end
	end

	describe 'Creating a new points event' do
		it 'is valid with valid inputs' do
			visit new_point_event_path
			fill_in 'point_event_name', with: 'Test Event'
			fill_in 'point_event_description', with: 'Test Description'
			fill_in 'point_event_points', with: 5
			fill_in 'point_event_eventType', with: 'Test Type'
			click_on 'Add Points Event'
			visit point_event_index_path
			expect(page).to have_content('Test Event')
		end

		it 'is valid without a description' do
			visit new_point_event_path
			fill_in 'point_event_name', with: 'Test Event'
			fill_in 'point_event_points', with: 5
			fill_in 'point_event_eventType', with: 'Test Type'
			click_on 'Add Points Event'
			visit point_event_index_path
			expect(page).to have_content('Test Event')
		end

		it 'is not valid without a name' do
			visit new_point_event_path
			fill_in 'point_event_description', with: 'Test Description'
			fill_in 'point_event_points', with: 5
			fill_in 'point_event_eventType', with: 'Test Type'
			click_on 'Add Points Event'
			visit point_event_index_path
			expect(page).to_not have_content('Test Description')
		end

		it 'is not valid without points' do
			visit new_point_event_path
			fill_in 'point_event_name', with: 'Test Event'
			fill_in 'point_event_description', with: 'Test Description'
			fill_in 'point_event_eventType', with: 'Test Type'
			click_on 'Add Points Event'
			visit point_event_index_path
			expect(page).to_not have_content('Test Event')
		end

		it 'is valid with 0 points' do
			visit new_point_event_path
			fill_in 'point_event_name', with: 'Test Event'
			fill_in 'point_event_description', with: 'Test Description'
			fill_in 'point_event_points', with: 0
			fill_in 'point_event_eventType', with: 'Test Type'
			click_on 'Add Points Event'
			visit point_event_index_path
			expect(page).to have_content('Test Event')
		end

		it 'is not valid with negative points' do
			visit new_point_event_path
			fill_in 'point_event_name', with: 'Test Event'
			fill_in 'point_event_description', with: 'Test Description'
			fill_in 'point_event_points', with: -1
			fill_in 'point_event_eventType', with: 'Test Type'
			click_on 'Add Points Event'
			visit point_event_index_path
			expect(page).to_not have_content('Test Event')
		end

		it 'is not valid without an event type' do
			visit new_point_event_path
			fill_in 'point_event_name', with: 'Test Event'
			fill_in 'point_event_description', with: 'Test Description'
			fill_in 'point_event_points', with: 5
			click_on 'Add Points Event'
			visit point_event_index_path
			expect(page).to_not have_content('Test Event')
		end
	end

	describe 'Reading an existing event' do
		it 'reads events correctly' do
			event = PointEvent.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						eventType: 'Test Type')
			visit point_event_path(id: event.id)
			expect(page).to have_content('Test Event')
			expect(page).to have_content('Test Description')
			expect(page).to have_content('5')
			expect(page).to have_content('Test Type')
		end
	end

	describe 'Updating an event' do
		it 'is valid with valid changes' do
			event = PointEvent.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						eventType: 'Test Type')
			visit edit_point_event_path(id: event.id)
			fill_in 'point_event_name', with: "Edited Event Name"
			click_on 'Save Changes to Points Event'
			visit point_event_index_path
			expect(page).to have_content('Edited Event Name')
		end

		it 'is valid with the description deleted' do
			event = PointEvent.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						eventType: 'Test Type')
			visit edit_point_event_path(id: event.id)
			fill_in 'point_event_name', with: "Edited Event Name"
			fill_in 'point_event_description', with: ""
			click_on 'Save Changes to Points Event'
			visit point_event_index_path
			expect(page).to have_content('Edited Event Name')
		end

		it 'is not valid without a name' do
			event = PointEvent.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						eventType: 'Test Type')
			visit edit_point_event_path(id: event.id)
			fill_in 'point_event_name', with: ""
			fill_in 'point_event_description', with: "Edited Test Description"
			click_on 'Save Changes to Points Event'
			visit point_event_index_path
			expect(page).to_not have_content('Edited Test Description')
		end

		it 'is not valid without points' do
			event = PointEvent.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						eventType: 'Test Type')
			visit edit_point_event_path(id: event.id)
			fill_in 'point_event_points', with: ""
			fill_in 'point_event_description', with: "Edited Test Description"
			click_on 'Save Changes to Points Event'
			visit point_event_index_path
			expect(page).to_not have_content('Edited Test Description')
		end

		it 'is valid with 0 points' do
			event = PointEvent.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						eventType: 'Test Type')
			visit edit_point_event_path(id: event.id)
			fill_in 'point_event_points', with: 0
			fill_in 'point_event_description', with: "Edited Test Description"
			click_on 'Save Changes to Points Event'
			visit point_event_index_path
			expect(page).to have_content('Edited Test Description')
		end

		it 'is not valid with negative points' do
			event = PointEvent.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						eventType: 'Test Type')
			visit edit_point_event_path(id: event.id)
			fill_in 'point_event_points', with: -5
			fill_in 'point_event_description', with: "Edited Test Description"
			click_on 'Save Changes to Points Event'
			visit point_event_index_path
			expect(page).to_not have_content('Edited Test Description')
		end

		it 'is not valid without an event type' do
			event = PointEvent.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						eventType: 'Test Type')
			visit edit_point_event_path(id: event.id)
			fill_in 'point_event_eventType', with: ""
			fill_in 'point_event_description', with: "Edited Test Description"
			click_on 'Save Changes to Points Event'
			visit point_event_index_path
			expect(page).to_not have_content('Edited Test Description')
		end
	end

	describe 'Deleting a points event' do
		it 'succeeded in deleting one event' do
			event = PointEvent.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						eventType: 'Test Type')
			visit point_event_index_path
			expect(page).to have_content('Test Event')

			visit delete_point_event_path(id: event.id)
			click_on 'Delete'
			a = page.driver.browser.switch_to.alert
			a.accept

			visit point_event_index_path
			expect(page).to_not have_content('Test Event')
		end

		it 'succeeded in deleting three events' do
			event1 = PointEvent.create!(name: 'Test Event 1',
						description: 'Test Description 1',
						points: 5,
						eventType: 'Test Type 1')
			event2 = PointEvent.create!(name: 'Test Event 2',
						description: 'Test Description 2',
						points: 5,
						eventType: 'Test Type 2')
			event3 = PointEvent.create!(name: 'Test Event 3',
						description: 'Test Description 3',
						points: 5,
						eventType: 'Test Type 3')

			visit point_event_index_path
			expect(page).to have_content('Test Event 1')
			expect(page).to have_content('Test Event 2')
			expect(page).to have_content('Test Event 3')

			visit delete_point_event_path(id: event2.id)
			click_on 'Delete'
			a = page.driver.browser.switch_to.alert
			a.accept

			visit point_event_index_path
			expect(page).to have_content('Test Event 1')
			expect(page).to_not have_content('Test Event 2')
			expect(page).to have_content('Test Event 3')

			visit delete_point_event_path(id: event1.id)
			click_on 'Delete'
			a2 = page.driver.browser.switch_to.alert
			a2.accept

			visit point_event_index_path
			expect(page).to_not have_content('Test Event 1')
			expect(page).to_not have_content('Test Event 2')
			expect(page).to have_content('Test Event 3')

			visit delete_point_event_path(id: event3.id)
			click_on 'Delete'
			a3 = page.driver.browser.switch_to.alert
			a3.accept

			visit point_event_index_path
			expect(page).to_not have_content('Test Event 1')
			expect(page).to_not have_content('Test Event 2')
			expect(page).to_not have_content('Test Event 3')
		end
	end
end

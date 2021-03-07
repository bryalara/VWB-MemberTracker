require 'rails_helper'

RSpec.describe 'PointEvents', type: :feature do
	setup do
		login_with_oauth
	end

	describe 'index page' do
		it 'shows the right content' do
			visit event_index_path
			expect(page).to have_content('Points Events')
		end
	end

	describe 'Creating a new points event' do
		setup do 
			visit new_point_event_path
			fill_in 'point_event_name', with: 'Test Event'
			fill_in 'point_event_description', with: 'Test Description'
			fill_in 'point_event_points', with: 5
		end
		
		it 'is valid with valid inputs' do
			click_on 'Add Points Event'
			visit event_index_path
			expect(page).to have_content('Test Event')
		end

		it 'is valid without a description' do
			fill_in 'point_event_description', with: ""
			click_on 'Add Points Event'
			visit event_index_path
			expect(page).to have_content('Test Event')
		end

		it 'is not valid without a name' do
			fill_in 'point_event_name', with: nil
			click_on 'Add Points Event'
			visit event_index_path
			expect(page).to_not have_content('Test Description')
		end

		it 'is not valid without points' do
			fill_in 'point_event_points', with: nil
			click_on 'Add Points Event'
			visit event_index_path
			expect(page).to_not have_content('Test Event')
		end

		it 'is valid with 0 points' do
			fill_in 'point_event_points', with: 0
			click_on 'Add Points Event'
			visit event_index_path
			expect(page).to have_content('Test Event')
		end

		it 'is not valid with negative points' do
			fill_in 'point_event_points', with: -1
			click_on 'Add Points Event'
			visit event_index_path
			expect(page).to_not have_content('Test Event')
		end
	end

	describe 'Reading an existing event' do
		setup do
			event = PointEvent.create!(name: 'Test Event',
				description: 'Test Description',
				points: 5)
			visit point_event_path(id: event.id)
		end

		it 'reads events correctly' do
			expect(page).to have_content('Test Event')
			expect(page).to have_content('Test Description')
			expect(page).to have_content('5')
		end
	end

	describe 'Updating an event' do
		setup do
			event = PointEvent.create!(name: 'Test Event',
				description: 'Test Description',
				points: 5)
			visit edit_point_event_path(id: event.id)
		end

		it 'is valid with valid changes' do
			fill_in 'point_event_name', with: "Edited Event Name"
			click_on 'Save Changes to Points Event'
			visit event_index_path
			expect(page).to have_content('Edited Event Name')
		end

		it 'is valid with the description deleted' do
			fill_in 'point_event_name', with: "Edited Event Name"
			fill_in 'point_event_description', with: nil
			click_on 'Save Changes to Points Event'
			visit event_index_path
			expect(page).to have_content('Edited Event Name')
		end

		it 'is not valid without a name' do
			fill_in 'point_event_name', with: nil
			fill_in 'point_event_description', with: "Edited Test Description"
			click_on 'Save Changes to Points Event'
			visit event_index_path
			expect(page).to_not have_content('Edited Test Description')
		end

		it 'is not valid without points' do
			fill_in 'point_event_points', with: nil
			fill_in 'point_event_description', with: "Edited Test Description"
			click_on 'Save Changes to Points Event'
			visit event_index_path
			expect(page).to_not have_content('Edited Test Description')
		end

		it 'is valid with 0 points' do
			fill_in 'point_event_points', with: 0
			fill_in 'point_event_description', with: "Edited Test Description"
			click_on 'Save Changes to Points Event'
			visit event_index_path
			expect(page).to have_content('Edited Test Description')
		end

		it 'is not valid with negative points' do
			fill_in 'point_event_points', with: -5
			fill_in 'point_event_description', with: "Edited Test Description"
			click_on 'Save Changes to Points Event'
			visit event_index_path
			expect(page).to_not have_content('Edited Test Description')
		end
	end

	describe 'Deleting a points event' do
		it 'succeeded in deleting one event' do
			event = PointEvent.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5)
			visit event_index_path
			expect(page).to have_content('Test Event')

			visit delete_point_event_path(id: event.id)
			click_on 'Delete'
			sleep(1)
			a = page.driver.browser.switch_to.alert
			a.accept
			sleep(1)

			visit event_index_path
			expect(page).to_not have_content('Test Event')
		end

		it 'succeeded in deleting three events' do
			event1 = PointEvent.create!(name: 'Test Event 1',
						description: 'Test Description 1',
						points: 5)
			event2 = PointEvent.create!(name: 'Test Event 2',
						description: 'Test Description 2',
						points: 5)
			event3 = PointEvent.create!(name: 'Test Event 3',
						description: 'Test Description 3',
						points: 5)

			visit event_index_path
			expect(page).to have_content('Test Event 1')
			expect(page).to have_content('Test Event 2')
			expect(page).to have_content('Test Event 3')

			visit delete_point_event_path(id: event2.id)
			click_on 'Delete'
			sleep(1)
			a = page.driver.browser.switch_to.alert
			a.accept
			sleep(1)

			visit event_index_path
			expect(page).to have_content('Test Event 1')
			expect(page).to_not have_content('Test Event 2')
			expect(page).to have_content('Test Event 3')

			visit delete_point_event_path(id: event1.id)
			click_on 'Delete'
			sleep(1)
			a2 = page.driver.browser.switch_to.alert
			a2.accept
			sleep(1)

			visit event_index_path
			expect(page).to_not have_content('Test Event 1')
			expect(page).to_not have_content('Test Event 2')
			expect(page).to have_content('Test Event 3')

			visit delete_point_event_path(id: event3.id)
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
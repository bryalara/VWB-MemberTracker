require 'rails_helper'

RSpec.describe 'CSV', type: :feature do
	setup do
		login_with_oauth
	end

	describe 'Cheking users csv features' do
		it 'have user CSV features in index page' do
			visit users_path
			expect(page).to have_content('Import Data From CSV file')
			expect(page).to have_content('DOWNLOAD EMAIL LIST')
			expect(page).to have_content('BACKUP ALL USERS\' INFORMATION')
		end

		it 'can download users email list' do
			visit users_path
			click_on 'Download Email List', match: :first
		end

		it 'can download users info' do
			visit users_path
			click_on 'backup all users\' information', match: :first
		end

		it 'import CSV' do
			visit users_path
			click_on 'Import CSV', match: :first
		end
	end

	describe 'Cheking events csv features' do
		it 'have user CSV features in index page' do
			visit event_index_path
			# expect(page).to have_content('Import Data From CSV file')
			expect(page).to have_content('DOWNLOAD EVENTS LIST')
			expect(page).to have_content('DOWNLOAD USERS\' PARTICIPATION')
		end

		it 'can download events list' do
			event = Event.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						startDate: DateTime.now,
						endDate: DateTime.now + 1.week,
						capacity: 5)
			visit event_index_path
			click_on 'Download Events List', match: :first
		end

		it 'can download events-users' do
			event = Event.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						startDate: DateTime.now,
						endDate: DateTime.now + 1.week,
						capacity: 5)
			visit event_index_path
			click_on 'Download Users\' Participation', match: :first
		end

		it 'import CSV' do
			visit event_index_path
			click_on 'Import CSV', match: :first
		end
	end

	describe 'Cheking pointevents csv features' do
		it 'have user CSV features in index page' do
			visit point_event_index_path
			# expect(page).to have_content('Import Data From CSV file')
			expect(page).to have_content('DOWNLOAD ENGAGEMENTS LIST')
			expect(page).to have_content('DOWNLOAD USERS\' ENGAGEMENT')
		end

		it 'can download events list' do
			event = Event.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						startDate: DateTime.now,
						endDate: DateTime.now + 1.week,
						capacity: 5)
			visit event_index_path
			click_on 'Download Engagements List', match: :first
		end

		it 'can download events-users' do
			event = Event.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						startDate: DateTime.now,
						endDate: DateTime.now + 1.week,
						capacity: 5)
			visit event_index_path
			click_on 'Download Users\' Engagement', match: :first
		end

		it 'import CSV' do
			visit point_event_index_path
			click_on 'Import CSV', match: :first
		end
	end
end
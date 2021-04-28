require 'rails_helper'

RSpec.describe 'CSV', type: :feature do
	setup do
		login_with_oauth
	end

	describe 'Cheking users csv features' do
		it 'have user CSV features in index page' do
			visit users_path
			expect(page).to have_content('Import')
			expect(page).to have_content('Download')
			# expect(page).to have_content('Backup')
		end

		it 'can download users email list' do
			visit users_path
			click_on 'Download', match: :first
		end

		it 'can download users info' do
			visit users_path
			click_on 'Backup', match: :first
		end

		it 'import CSV' do
			visit users_path
			click_on 'Import', match: :first
		end
	end

	describe 'Cheking events csv features' do
		it 'have user CSV features in index page' do
			visit event_index_path
			expect(page).to have_content('Back Up Events')
			expect(page).to have_content('Download')
			# expect(page).to have_content('Download\nAttendance')
		end

		it 'can download events list' do
			event = Event.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						startDate: DateTime.now,
						endDate: DateTime.now + 1.week,
						capacity: 5)
			visit event_index_path
			click_on 'Download', match: :first
		end

		# it 'can download events-users' do
		# 	event = Event.create!(name: 'Test Event',
		# 				description: 'Test Description',
		# 				points: 5,
		# 				startDate: DateTime.now,
		# 				endDate: DateTime.now + 1.week,
		# 				capacity: 5)
		# 	visit event_index_path
		# 	click_on 'Download Attendance', match: :first
		# end

		it 'import CSV' do
			visit event_index_path
			click_on 'Import', match: :first
		end

		# it 'import CSV 2' do
		# 	visit event_index_path
		# 	click_on 'Import Attendance', match: :first
		# end
	end

	describe 'Cheking pointevents csv features' do
		it 'have user CSV features in index page' do
			visit event_index_path
			# expect(page).to have_content('Import Data From CSV file')
			expect(page).to have_content('Download')
			# expect(page).to have_content('Download Attendance')
		end

		it 'can download events list' do
			event = Event.create!(name: 'Test Event',
						description: 'Test Description',
						points: 5,
						startDate: DateTime.now,
						endDate: DateTime.now + 1.week,
						capacity: 5)
			visit event_index_path
			click_on 'Download', match: :first
		end

		# it 'can download events-users' do
		# 	event = Event.create!(name: 'Test Event',
		# 				description: 'Test Description',
		# 				points: 5,
		# 				startDate: DateTime.now,
		# 				endDate: DateTime.now + 1.week,
		# 				capacity: 5)
		# 	visit event_index_path
		# 	click_on 'Download Attendance', match: :first
		# end

		# it 'import CSV' do
		# 	visit point_event_index_path
		# 	click_on 'Import', match: :first
		# end

		# it 'import CSV 2' do
		# 	visit point_event_index_path
		# 	click_on 'Import', match: :first
		# end
	end
end
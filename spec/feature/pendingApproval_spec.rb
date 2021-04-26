require 'rails_helper'

RSpec.describe 'PendingApproval', type: :feature do

	setup do
		#Logging in as new user
		login_with_oauth
	end

	describe 'logged in as admin' do
		it 'logged in admin sees users index' do
			visit users_path	
			sleep(2)
			expect(page).to have_content('ADMIN DASHBOARD')
		end
	end

	describe 'Uploading csv of needing approval users' do
		setup do
			#Creating member user
			visit users_path
			sleep(1)
			attach_file('file', File.join(Rails.root, '/spec/support/Users_test.csv'))
			sleep(1)
			click_button 'Import'
			sleep(2)
			
		end

		it 'Check pending users created' do
			visit pending_approval_path
			sleep(1)
			expect(page).to_not have_content('No users need approving')
		end

		it 'Approving all users pending approval' do
			visit pending_approval_path(select_all: true)
			sleep(1)
			expect(page).to have_content('☑️')
			click_on 'Approve Selected'
			sleep(1)
			expect(page).to have_content('No users need approving')
			visit users_path
			sleep(1)
			start=1

			while start<10
				expect(page).to have_content("Test #{start}")
				start+=1
			end
		end

		it 'Destroying all users pending approval' do
			visit pending_approval_path(select_all: true)
			sleep(1)
			expect(page).to have_content('☑️')
			click_on 'Destroy Selected'
			wait = Selenium::WebDriver::Wait.new ignore: Selenium::WebDriver::Error::NoSuchAlertError
			alert = wait.until { page.driver.browser.switch_to.alert }
			alert.accept
			sleep(1)
			expect(page).to have_content('No users need approving')
			visit users_path
			sleep(1)
			start=1

			while start<10
				expect(page).to_not have_content("Test #{start}")
				start+=1
			end
		end

	
		
    end
end
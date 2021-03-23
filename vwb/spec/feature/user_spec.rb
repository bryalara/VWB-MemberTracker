require 'rails_helper'

RSpec.describe 'Users', type: :feature do

	setup do
		login_with_oauth
	end

	describe 'index page' do
		it 'shows the right content' do
			visit users_path
			sleep(1)
			expect(page).to have_content('USERS')
		end
	end

	describe 'Creating a new user' do
		it 'is valid with valid inputs' do
			visit new_user_path
			fill_in 'user_email', with: 'featuretesting@tamu.edu'
			fill_in 'user_firstName', with: 'John'
			fill_in 'user_lastName', with: 'Doe'
			select 'Member', :from => 'user_role'
			fill_in 'user_phoneNumber', with: '1234567890'
			select 'Sophomore', :from => 'user_classification'
			select 'M', :from => 'user_tShirtSize'
			fill_in 'user_participationPoints', with: 5
			# check('optInEmail', allow_label_click: true)
			# check('approved', allow_label_click: true)
			check 'user_optInEmail'
			check 'user_approved'
			sleep(1)
			
			click_on 'Create User'
			sleep(1)
			visit users_path
			expect(page).to have_content('John Doe')
		end

		it 'is not valid without an email' do
			visit new_user_path
			
			select 'Member', :from => 'user_role'
			fill_in 'user_firstName', with: 'John'
			fill_in 'user_lastName', with: 'Doe'
			fill_in 'user_phoneNumber', with: '1234567890'
			select 'M', :from => 'user_tShirtSize'
			fill_in 'user_participationPoints', with: 5
			select 'Sophomore', :from => 'user_classification'
			check 'user_optInEmail'
			check 'user_approved'
			
			click_on 'Create User'
			visit users_path
			expect(page).to_not have_content('featuretesting@tamu.edu')
		end

		it 'is not valid without a role' do
			visit new_user_path
			
			fill_in 'user_email', with: 'featuretesting@tamu.edu'
			fill_in 'user_firstName', with: 'John'
			fill_in 'user_lastName', with: 'Doe'
			fill_in 'user_phoneNumber', with: '1234567890'
			select 'M', :from => 'user_tShirtSize'
			fill_in 'user_participationPoints', with: 5
			select 'Sophomore', :from => 'user_classification'
			check 'user_optInEmail'
			check 'user_approved'
			
			click_on 'Create User'
			visit users_path
			expect(page).to_not have_content('John')
		end

		it 'is not valid with out of range role' do
			visit new_user_path
			
			fill_in 'user_email', with: 'featuretesting@tamu.edu'
			select 'Select a Role', :from => 'user_role'
			fill_in 'user_firstName', with: 'John'
			fill_in 'user_lastName', with: 'Doe'
			fill_in 'user_phoneNumber', with: '1234567890'
			select 'M', :from => 'user_tShirtSize'
			fill_in 'user_participationPoints', with: 5
			select 'Sophomore', :from => 'user_classification'
			check 'user_optInEmail'
			check 'user_approved'
			
			click_on 'Create User'
			visit users_path
			expect(page).to_not have_content('John')
		end

		it 'is not valid with out first name' do
			visit new_user_path
			
			fill_in 'user_email', with: 'featuretesting@tamu.edu'
			select 'Member', :from => 'user_role'
			fill_in 'user_lastName', with: 'Doe'
			fill_in 'user_phoneNumber', with: '1234567890'
			select 'M', :from => 'user_tShirtSize'
			fill_in 'user_participationPoints', with: 5
			select 'Sophomore', :from => 'user_classification'
			check 'user_optInEmail'
			check 'user_approved'
			
			click_on 'Create User'
			visit users_path
			expect(page).to_not have_content('John')
		end

		it 'is not valid with out last name' do
			visit new_user_path
			
			fill_in 'user_email', with: 'featuretesting@tamu.edu'
			select 'Member', :from => 'user_role'
			fill_in 'user_firstName', with: 'John'
			fill_in 'user_phoneNumber', with: '1234567890'
			select 'M', :from => 'user_tShirtSize'
			fill_in 'user_participationPoints', with: 5
			select 'Sophomore', :from => 'user_classification'
			check 'user_optInEmail'
			check 'user_approved'
			
			click_on 'Create User'
			visit users_path
			expect(page).to_not have_content('Doe')
		end

		it 'is not valid with out phone number' do
			visit new_user_path
			
			fill_in 'user_email', with: 'featuretesting@tamu.edu'
			select 'Member', :from => 'user_role'
			fill_in 'user_firstName', with: 'John'
			fill_in 'user_lastName', with: 'Doe'
			select 'M', :from => 'user_tShirtSize'
			fill_in 'user_participationPoints', with: 5
			select 'Sophomore', :from => 'user_classification'
			check 'user_optInEmail'
			check 'user_approved'
			
			click_on 'Create User'
			visit users_path
			expect(page).to_not have_content('John')
		end

		it 'is not valid with out full 10 digit number' do
			visit new_user_path
			
			fill_in 'user_email', with: 'featuretesting@tamu.edu'
			select 'Member', :from => 'user_role'
			fill_in 'user_firstName', with: 'John'
			fill_in 'user_lastName', with: 'Doe'
			fill_in 'user_phoneNumber', with: '123456789'
			select 'M', :from => 'user_tShirtSize'
			fill_in 'user_participationPoints', with: 5
			select 'Sophomore', :from => 'user_classification'
			check 'user_optInEmail'
			check 'user_approved'
			
			click_on 'Create User'
			visit users_path
			expect(page).to_not have_content('John')
		end

		it 'is not valid with out classification' do
			visit new_user_path
			
			fill_in 'user_email', with: 'featuretesting@tamu.edu'
			select 'Member', :from => 'user_role'
			fill_in 'user_firstName', with: 'John'
			fill_in 'user_lastName', with: 'Doe'
			fill_in 'user_phoneNumber', with: '1234567890'
			select 'M', :from => 'user_tShirtSize'
			fill_in 'user_participationPoints', with: 5
			check 'user_optInEmail'
			check 'user_approved'
			
			click_on 'Create User'
			visit users_path
			expect(page).to_not have_content('John')
		end

		it 'is not valid with out tshirt size' do
			visit new_user_path
			
			fill_in 'user_email', with: 'featuretesting@tamu.edu'
			select 'Member', :from => 'user_role'
			fill_in 'user_firstName', with: 'John'
			fill_in 'user_lastName', with: 'Doe'
			fill_in 'user_phoneNumber', with: '1234567890'
			fill_in 'user_participationPoints', with: 5
			select 'Sophomore', :from => 'user_classification'
			check 'user_optInEmail'
			check 'user_approved'
			
			click_on 'Create User'
			visit users_path
			expect(page).to_not have_content('John')
		end

		it 'is valid with optInEmail unhecked' do
			visit new_user_path
			
			fill_in 'user_email', with: 'featuretesting@tamu.edu'
			select 'Member', :from => 'user_role'
			fill_in 'user_firstName', with: 'John'
			fill_in 'user_lastName', with: 'Doe'
			fill_in 'user_phoneNumber', with: '1234567890'
			select 'M', :from => 'user_tShirtSize'
			fill_in 'user_participationPoints', with: 5
			select 'Sophomore', :from => 'user_classification'
			check 'user_approved'
			
			click_on 'Create User'
			visit users_path
			expect(page).to have_content('John')
		end

		it 'is not valid with out approved status' do
			visit new_user_path
			
			fill_in 'user_email', with: 'featuretesting@tamu.edu'
			select 'Member', :from => 'user_role'
			fill_in 'user_firstName', with: 'John'
			fill_in 'user_lastName', with: 'Doe'
			fill_in 'user_phoneNumber', with: '1234567890'
			select 'M', :from => 'user_tShirtSize'
			fill_in 'user_participationPoints', with: 5
			select 'Sophomore', :from => 'user_classification'
			check 'user_optInEmail'
			
			click_on 'Create User'
			visit users_path
			expect(page).to_not have_content('John')
		end

		it 'is not valid with out points' do
			visit new_user_path
			
			fill_in 'user_email', with: 'featuretesting@tamu.edu'
			select 'Member', :from => 'user_role'
			fill_in 'user_firstName', with: 'John'
			fill_in 'user_lastName', with: 'Doe'
			fill_in 'user_phoneNumber', with: '1234567890'
			select 'M', :from => 'user_tShirtSize'
			select 'Sophomore', :from => 'user_classification'
			check 'user_optInEmail'
			check 'user_approved'
			
			click_on 'Create User'
			visit users_path
			expect(page).to_not have_content('John')
		end

		it 'is not valid with negative points' do
			visit new_user_path
			
			fill_in 'user_email', with: 'featuretesting@tamu.edu'
			select 'Member', :from => 'user_role'
			fill_in 'user_firstName', with: 'John'
			fill_in 'user_lastName', with: 'Doe'
			fill_in 'user_phoneNumber', with: '1234567890'
			select 'M', :from => 'user_tShirtSize'
			fill_in 'user_participationPoints', with: -5
			select 'Sophomore', :from => 'user_classification'
			check 'user_optInEmail'
			check 'user_approved'
			
			click_on 'Create User'
			visit users_path
			expect(page).to_not have_content('John')
		end

		it 'is valid with 0 points' do
			visit new_user_path
			
			fill_in 'user_email', with: 'featuretesting@tamu.edu'
			select 'Member', :from => 'user_role'
			fill_in 'user_firstName', with: 'John'
			fill_in 'user_lastName', with: 'Doe'
			fill_in 'user_phoneNumber', with: '1234567890'
			select 'M', :from => 'user_tShirtSize'
			fill_in 'user_participationPoints', with: 0
			select 'Sophomore', :from => 'user_classification'
			check 'user_optInEmail'
			check 'user_approved'
			
			click_on 'Create User'
			visit users_path
			expect(page).to have_content('John')
		end

	end

	describe 'Reading an existing user' do
		it 'reads users correctly' do
			user = User.create!(email: 'featureRead@tamu.edu',
						role: 0,
						firstName: 'Feature',
						lastName: 'Testing',
						phoneNumber: '1231231234',
						tShirtSize: 'M',
						participationPoints: 5,
						classification: 'Senior',
						optInEmail: true,
						approved: true,
					)
			visit users_path(id: user.id)
			expect(page).to have_content('Feature')
			expect(page).to have_content('Testing')
			expect(page).to have_content('1231231234')
			expect(page).to have_content('M')
			expect(page).to have_content('featureRead@tamu.edu')
			expect(page).to have_content('Senior')
			expect(page).to have_content('5')
		end
	end


	describe 'Updating a user' do
		it 'is valid with email change' do
			user = User.create!(email: 'featureRead@tamu.edu',
				role: 0,
				firstName: 'Feature',
				lastName: 'Testing',
				phoneNumber: '1231231234',
				tShirtSize: 'M',
				participationPoints: 5,
				classification: 'Senior',
				optInEmail: true,
				approved: true,
			)
			visit edit_user_path(id: user.id)
			fill_in 'user_email', with: 'UpdatingTest@tamu.edu'
			click_on 'Update User'
			visit users_path
			expect(page).to have_content('UpdatingTest@tamu.edu')
		end

		it 'is not valid with email change to nil' do
			user = User.create!(email: 'featureRead@tamu.edu',
				role: 0,
				firstName: 'Feature',
				lastName: 'Testing',
				phoneNumber: '1231231234',
				tShirtSize: 'M',
				participationPoints: 5,
				classification: 'Senior',
				optInEmail: true,
				approved: true,
			)
			visit edit_user_path(id: user.id)
			fill_in 'user_email', with: nil
			click_on 'Update User'
			visit users_path
			expect(page).to have_content('featureRead@tamu.edu')
		end

		it 'is valid with valid firstName change' do
			user = User.create!(email: 'featureRead@tamu.edu',
				role: 0,
				firstName: 'Feature',
				lastName: 'Testing',
				phoneNumber: '1231231234',
				tShirtSize: 'M',
				participationPoints: 5,
				classification: 'Senior',
				optInEmail: true,
				approved: true,
			)
			visit edit_user_path(id: user.id)
			fill_in 'user_firstName', with: 'UpdatingTestFirst'
			click_on 'Update User'
			visit users_path
			expect(page).to have_content('UpdatingTestFirst')
		end

		it 'is not valid with valid firstName change to nil' do
			user = User.create!(email: 'featureRead@tamu.edu',
				role: 0,
				firstName: 'Feature',
				lastName: 'Testing',
				phoneNumber: '1231231234',
				tShirtSize: 'M',
				participationPoints: 5,
				classification: 'Senior',
				optInEmail: true,
				approved: true,
			)
			visit edit_user_path(id: user.id)
			fill_in 'user_firstName', with: nil
			click_on 'Update User'
			visit users_path
			expect(page).to have_content('Feature')
		end

		it 'is valid with valid lastName change' do
			user = User.create!(email: 'featureRead@tamu.edu',
				role: 0,
				firstName: 'Feature',
				lastName: 'Testing',
				phoneNumber: '1231231234',
				tShirtSize: 'M',
				participationPoints: 5,
				classification: 'Senior',
				optInEmail: true,
				approved: true,
			)
			visit edit_user_path(id: user.id)
			fill_in 'user_lastName', with: 'UpdatingTestLast'
			click_on 'Update User'
			visit users_path
			sleep(1)
			expect(page).to have_content('UpdatingTestLast')
		end

		it 'is not valid with valid lastName change to nil' do
			user = User.create!(email: 'featureRead@tamu.edu',
				role: 0,
				firstName: 'Feature',
				lastName: 'Testing',
				phoneNumber: '1231231234',
				tShirtSize: 'M',
				participationPoints: 5,
				classification: 'Senior',
				optInEmail: true,
				approved: true,
			)
			visit edit_user_path(id: user.id)
			fill_in 'user_lastName', with: nil
			click_on 'Update User'
			visit users_path
			expect(page).to have_content('Testing')
		end

		it 'is valid with valid role change' do
			user = User.create!(email: 'featureRead@tamu.edu',
				role: 0,
				firstName: 'Feature',
				lastName: 'Testing',
				phoneNumber: '1231231234',
				tShirtSize: 'M',
				participationPoints: 5,
				classification: 'Senior',
				optInEmail: true,
				approved: true,
			)
			visit edit_user_path(id: user.id)
			select 'Admin', :from => 'user_role'
			click_on 'Update User'
			visit users_path(id: user.id)
			expect(page).to have_content('Admin')
		end

		it 'is valid with valid phone number change' do
			user = User.create!(email: 'featureRead@tamu.edu',
				role: 0,
				firstName: 'Feature',
				lastName: 'Testing',
				phoneNumber: '1231231234',
				tShirtSize: 'M',
				participationPoints: 5,
				classification: 'Senior',
				optInEmail: true,
				approved: true,
			)
			visit edit_user_path(id: user.id)
			fill_in 'user_phoneNumber', with: '1231231235'
			click_on 'Update User'
			visit users_path
			expect(page).to have_content('1231231235')
		end

		it 'is not valid with phone number change less than 10 digits' do
			user = User.create!(email: 'featureRead@tamu.edu',
				role: 0,
				firstName: 'Feature',
				lastName: 'Testing',
				phoneNumber: '1231231234',
				tShirtSize: 'M',
				participationPoints: 5,
				classification: 'Senior',
				optInEmail: true,
				approved: true,
			)
			visit edit_user_path(id: user.id)
			fill_in 'user_phoneNumber', with: '12312312345'
			click_on 'Update User'
			visit users_path
			expect(page).to_not have_content('12312312345')
		end

		it 'is valid with valid classification change' do
			user = User.create!(email: 'featureRead@tamu.edu',
				role: 0,
				firstName: 'Feature',
				lastName: 'Testing',
				phoneNumber: '1231231234',
				tShirtSize: 'M',
				participationPoints: 5,
				classification: 'Senior',
				optInEmail: true,
				approved: true,
			)
			visit edit_user_path(id: user.id)
			select 'Junior', :from => 'user_classification'
			click_on 'Update User'
			visit users_path(id: user.id)
			expect(page).to have_content('Junior')
		end

		it 'is valid with valid tShirtSize change' do
			user = User.create!(email: 'featureRead@tamu.edu',
				role: 0,
				firstName: 'Feature',
				lastName: 'Testing',
				phoneNumber: '1231231234',
				tShirtSize: 'M',
				participationPoints: 5,
				classification: 'Senior',
				optInEmail: true,
				approved: true,
			)
			visit edit_user_path(id: user.id)
			
			select 'XL', :from => 'user_tShirtSize'
			click_on 'Update User'
			visit users_path(id: user.id)
			expect(page).to have_content('XL')
		end

		it 'is valid with valid optInEmail change' do
			user = User.create!(email: 'featureRead@tamu.edu',
				role: 0,
				firstName: 'Feature',
				lastName: 'Testing',
				phoneNumber: '1231231234',
				tShirtSize: 'M',
				participationPoints: 5,
				classification: 'Senior',
				optInEmail: false,
				approved: true,
			)
			visit edit_user_path(id: user.id)
			check 'user_optInEmail'
			click_on 'Update User'
			visit users_path(id: user.id)
			expect(page).to_not have_content('false')
		end

		it 'is valid with valid points change' do
			user = User.create!(email: 'featureRead@tamu.edu',
				role: 0,
				firstName: 'Feature',
				lastName: 'Testing',
				phoneNumber: '1231231234',
				tShirtSize: 'M',
				participationPoints: 5,
				classification: 'Senior',
				optInEmail: true,
				approved: true,
			)
			visit edit_user_path(id: user.id)
			fill_in 'user_participationPoints', with: 15
			click_on 'Update User'
			visit users_path(id: user.id)
			expect(page).to have_content('15')
		end

		it 'is not valid with points change to negative' do
			user = User.create!(email: 'featureRead@tamu.edu',
				role: 0,
				firstName: 'Feature',
				lastName: 'Testing',
				phoneNumber: '1231231234',
				tShirtSize: 'M',
				participationPoints: 5,
				classification: 'Senior',
				optInEmail: true,
				approved: true,
			)
			visit edit_user_path(id: user.id)
			fill_in 'user_participationPoints', with: -15
			click_on 'Update User'
			visit users_path(id: user.id)
			expect(page).to_not have_content('-15')
		end

		it 'is valid with valid approved change' do
			user = User.create!(email: 'featureRead@tamu.edu',
				role: 0,
				firstName: 'Feature',
				lastName: 'Testing',
				phoneNumber: '1231231234',
				tShirtSize: 'M',
				participationPoints: 5,
				classification: 'Senior',
				optInEmail: true,
				approved: true,
			)
			visit edit_user_path(id: user.id)
			uncheck 'user_approved'
			click_on 'Update User'
			visit pendingApproval_path
			sleep(1)
			expect(page).to have_content('false')
		end
	end

	describe 'Deleting a user' do
		it 'succeeded in deleting one user' do
			user = User.create!(email: 'featureRead@tamu.edu',
				role: 0,
				firstName: 'Feature',
				lastName: 'Testing',
				phoneNumber: '1231231234',
				tShirtSize: 'M',
				participationPoints: 5,
				classification: 'Senior',
				optInEmail: true,
				approved: true,
			)
			visit users_path 
			expect(page).to have_content('featureRead@tamu.edu')
			visit user_path(id: user.id)
			
			puts user_path(id: user.id)
			first("#delete-btn").click
			sleep(1)
			page.driver.browser.switch_to.alert.accept
			sleep(1)

			visit users_path
			expect(page).to_not have_content('featureRead@tamu.edu')
		end

		it 'succeeded in deleting 3 users' do
			user1 = User.create!(email: 'featureRead1@tamu.edu',
				role: 0,
				firstName: 'Feature1',
				lastName: 'Testing1',
				phoneNumber: '1231231234',
				tShirtSize: 'M',
				participationPoints: 5,
				classification: 'Senior',
				optInEmail: true,
				approved: true,
			)
			user2 = User.create!(email: 'featureRead2@tamu.edu',
				role: 0,
				firstName: 'Feature2',
				lastName: 'Testing2',
				phoneNumber: '1231231234',
				tShirtSize: 'M',
				participationPoints: 5,
				classification: 'Senior',
				optInEmail: true,
				approved: true,
			)
			user3 = User.create!(email: 'featureRead3@tamu.edu',
				role: 0,
				firstName: 'Feature3',
				lastName: 'Testing3',
				phoneNumber: '1231231234',
				tShirtSize: 'M',
				participationPoints: 5,
				classification: 'Senior',
				optInEmail: true,
				approved: true,
			)
			visit users_path 

			expect(page).to have_content('featureRead1@tamu.edu')
			expect(page).to have_content('featureRead2@tamu.edu')
			expect(page).to have_content('featureRead3@tamu.edu')

			visit user_path(id: user1.id)
			first("#delete-btn").click
			sleep(1)
			page.driver.browser.switch_to.alert.accept
			sleep(1)
			

			visit user_path(id: user2.id)
			first("#delete-btn").click
			sleep(1)
			page.driver.browser.switch_to.alert.accept
			sleep(1)

			visit user_path(id: user3.id)
			first("#delete-btn").click
			sleep(1)
			page.driver.browser.switch_to.alert.accept
			sleep(1)

			visit users_path
			expect(page).to_not have_content('featureRead1@tamu.edu')
			expect(page).to_not have_content('featureRead2@tamu.edu')
			expect(page).to_not have_content('featureRead3@tamu.edu')
		end




	end


end
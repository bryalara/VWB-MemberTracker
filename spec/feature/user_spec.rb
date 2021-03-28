
require 'rails_helper'

RSpec.describe 'Users', type: :feature do

	setup do
		login_with_oauth
	end
	# #registration module test:
	# describe 'member login with google oauth' do
	# 	it 'shows the right content first time login' do
	# 		login_with_oauth_member_registration
	# 		#sleep(1)
	# 		#visit registration_user_path
	# 		expect(page).to have_content('Registration')
	# 	end
	# 	it 'register a the new user' do
	# 		login_with_oauth_member_registration
	# 		#sleep(1)
	# 		#visit registration_user_path
	# 		#expect(page).to have_content('Registration')
	# 		fill_in 'user_firstName', with: 'John'
	# 		fill_in 'user_lastName', with: 'Doe'
	# 		fill_in 'user_phoneNumber', with: '1234567890'
	# 		select 'Sophomore', :from => 'user_classification'
	# 		select 'M', :from => 'user_tShirtSize'
	# 		check 'user_optInEmail'
	# 		sleep(1)
			
	# 		click_on 'Create User'
	# 		login_with_oauth
	# 		visit pendingApproval_path
	# 		#expect(page).to have_content('entao@tamu.edu')
	# 	end
	# 	it 'member cannot visit users pages' do
	# 		login_with_oauth_member_registration
	# 		#sleep(1)
	# 		#visit registration_user_path
	# 		#expect(page).to have_content('Registration')
	# 		fill_in 'user_firstName', with: 'John'
	# 		fill_in 'user_lastName', with: 'Doe'
	# 		fill_in 'user_phoneNumber', with: '1234567890'
	# 		select 'Sophomore', :from => 'user_classification'
	# 		select 'M', :from => 'user_tShirtSize'
	# 		check 'user_optInEmail'
	# 		sleep(1)
			
	# 		click_on 'Create User'
	# 		visit users_path
	# 		#expect(page).to have_content('You are not an Admin')
	# 	end
	# 	it 'member cannot visit events pages' do
	# 		login_with_oauth_member_registration
	# 		#sleep(1)
	# 		#visit registration_user_path
	# 		#expect(page).to have_content('Registration')
	# 		fill_in 'user_firstName', with: 'John'
	# 		fill_in 'user_lastName', with: 'Doe'
	# 		fill_in 'user_phoneNumber', with: '1234567890'
	# 		select 'Sophomore', :from => 'user_classification'
	# 		select 'M', :from => 'user_tShirtSize'
	# 		check 'user_optInEmail'
	# 		sleep(1)
			
	# 		click_on 'Create User'
	# 		event_index_path
	# 		#expect(page).to have_content('You are not an Admin')
	# 	end
	# end

	describe "originalUserTesting" do
		#checking index render correctly
		describe 'index page' do
			it 'shows the right content' do
				visit users_path
				sleep(1)
				expect(page).to have_content('Users')
			end
		end
	
		# describe 'Creating a new user' do

		# 	it 'is valid with valid inputs' do
		# 		visit new_user_path
		# 		fill_in 'user_email', with: 'featuretesting1@tamu.edu'
		# 		fill_in 'user_firstName', with: 'John'
		# 		fill_in 'user_lastName', with: 'Doe'
		# 		select 'Member', :from => 'user_role'
		# 		fill_in 'user_phoneNumber', with: '1234567890'
		# 		select 'Sophomore', :from => 'user_classification'
		# 		select 'M', :from => 'user_tShirtSize'
		# 		fill_in 'user_participationPoints', with: 5
		# 		check 'user_optInEmail'
		# 		check 'user_approved'
		# 		sleep(1)
				
		# 		click_on 'Create User'
		# 		sleep(1)
		# 		visit users_path
		# 		expect(page).to have_content('featuretesting1@tamu.edu')
		# 	end
	
		# 	it 'is not valid without an email' do
		# 		visit new_user_path
				
		# 		select 'Member', :from => 'user_role'
		# 		fill_in 'user_firstName', with: 'John'
		# 		fill_in 'user_lastName', with: 'Doe'
		# 		fill_in 'user_phoneNumber', with: '1234567890'
		# 		select 'M', :from => 'user_tShirtSize'
		# 		fill_in 'user_participationPoints', with: 5
		# 		select 'Sophomore', :from => 'user_classification'
		# 		check 'user_optInEmail'
		# 		check 'user_approved'
		# 		sleep(1)
		# 		click_on 'Create User'
		# 		visit users_path
		# 		expect(page).to_not have_content('John')

		# 	end
	
		# 	it 'is not valid without a role' do
		# 		visit new_user_path
				
		# 		fill_in 'user_email', with: 'featuretesting2@tamu.edu'
		# 		fill_in 'user_firstName', with: 'John'
		# 		fill_in 'user_lastName', with: 'Doe'
		# 		fill_in 'user_phoneNumber', with: '1234567890'
		# 		select 'M', :from => 'user_tShirtSize'
		# 		fill_in 'user_participationPoints', with: 5
		# 		select 'Sophomore', :from => 'user_classification'
		# 		check 'user_optInEmail'
		# 		check 'user_approved'
		# 		click_on 'Create User'
		# 		visit users_path
		# 		expect(page).to_not have_content('John')
		# 	end
	
		# 	it 'is not valid with out first name' do
		# 		visit new_user_path
				
		# 		fill_in 'user_email', with: 'featuretesting4@tamu.edu'
		# 		select 'Member', :from => 'user_role'
		# 		fill_in 'user_lastName', with: 'Doe'
		# 		fill_in 'user_phoneNumber', with: '1234567890'
		# 		select 'M', :from => 'user_tShirtSize'
		# 		fill_in 'user_participationPoints', with: 5
		# 		select 'Sophomore', :from => 'user_classification'
		# 		check 'user_optInEmail'
		# 		check 'user_approved'
				
		# 		click_on 'Create User'
		# 		visit users_path
		# 		expect(page).to_not have_content('John')
		# 	end
	
		# 	it 'is not valid with out last name' do
		# 		visit new_user_path
				
		# 		fill_in 'user_email', with: 'featuretesting5@tamu.edu'
		# 		select 'Member', :from => 'user_role'
		# 		fill_in 'user_firstName', with: 'John'
		# 		fill_in 'user_phoneNumber', with: '1234567890'
		# 		select 'M', :from => 'user_tShirtSize'
		# 		fill_in 'user_participationPoints', with: 5
		# 		select 'Sophomore', :from => 'user_classification'
		# 		check 'user_optInEmail'
		# 		check 'user_approved'
				
		# 		click_on 'Create User'
		# 		visit users_path
		# 		expect(page).to_not have_content('Doe')
		# 	end
	
		# 	it 'is not valid with out phone number' do
		# 		visit new_user_path
				
		# 		fill_in 'user_email', with: 'featuretesting6@tamu.edu'
		# 		select 'Member', :from => 'user_role'
		# 		fill_in 'user_firstName', with: 'John'
		# 		fill_in 'user_lastName', with: 'Doe'
		# 		select 'M', :from => 'user_tShirtSize'
		# 		fill_in 'user_participationPoints', with: 5
		# 		select 'Sophomore', :from => 'user_classification'
		# 		check 'user_optInEmail'
		# 		check 'user_approved'
		# 		click_on 'Create User'
		# 		visit users_path
		# 		expect(page).to_not have_content('John')
		# 	end
	
		# 	it 'is not valid with out full 10 digit number' do
		# 		visit new_user_path
				
		# 		fill_in 'user_email', with: 'featuretesting7@tamu.edu'
		# 		select 'Member', :from => 'user_role'
		# 		fill_in 'user_firstName', with: 'John'
		# 		fill_in 'user_lastName', with: 'Doe'
		# 		fill_in 'user_phoneNumber', with: '123456789'
		# 		select 'M', :from => 'user_tShirtSize'
		# 		fill_in 'user_participationPoints', with: 5
		# 		select 'Sophomore', :from => 'user_classification'
		# 		check 'user_optInEmail'
		# 		check 'user_approved'
				
		# 		click_on 'Create User'
		# 		visit users_path
		# 		expect(page).to_not have_content('John')
		# 	end
	
		# 	it 'is not valid with out classification' do
		# 		visit new_user_path
				
		# 		fill_in 'user_email', with: 'featuretesting8@tamu.edu'
		# 		select 'Member', :from => 'user_role'
		# 		fill_in 'user_firstName', with: 'John'
		# 		fill_in 'user_lastName', with: 'Doe'
		# 		fill_in 'user_phoneNumber', with: '1234567890'
		# 		select 'M', :from => 'user_tShirtSize'
		# 		fill_in 'user_participationPoints', with: 5
		# 		check 'user_optInEmail'
		# 		check 'user_approved'
				
		# 		click_on 'Create User'
		# 		visit users_path
		# 		expect(page).to_not have_content('John')
		# 	end
	
		# 	it 'is not valid with out tshirt size' do
		# 		visit new_user_path
				
		# 		fill_in 'user_email', with: 'featuretesting9@tamu.edu'
		# 		select 'Member', :from => 'user_role'
		# 		fill_in 'user_firstName', with: 'John'
		# 		fill_in 'user_lastName', with: 'Doe'
		# 		fill_in 'user_phoneNumber', with: '1234567890'
		# 		fill_in 'user_participationPoints', with: 5
		# 		select 'Sophomore', :from => 'user_classification'
		# 		check 'user_optInEmail'
		# 		check 'user_approved'
				
		# 		click_on 'Create User'
		# 		visit users_path
		# 		expect(page).to_not have_content('John')
		# 	end
	
		# 	it 'is valid with optInEmail unhecked' do
		# 		visit new_user_path
				
		# 		fill_in 'user_email', with: 'featuretesting0@tamu.edu'
		# 		select 'Member', :from => 'user_role'
		# 		fill_in 'user_firstName', with: 'John'
		# 		fill_in 'user_lastName', with: 'Doe'
		# 		fill_in 'user_phoneNumber', with: '1234567890'
		# 		select 'M', :from => 'user_tShirtSize'
		# 		fill_in 'user_participationPoints', with: 5
		# 		select 'Sophomore', :from => 'user_classification'
		# 		uncheck 'user_optInEmail'
		# 		check 'user_approved'
		# 		click_on 'Create User'
		# 		visit users_path
		# 		expect(page).to have_content('John')
		# 	end
	
		# 	it 'is valid with approved unchecked' do
		# 		visit new_user_path
				
		# 		fill_in 'user_email', with: 'featuretesting11@tamu.edu'
		# 		select 'Member', :from => 'user_role'
		# 		fill_in 'user_firstName', with: 'John'
		# 		fill_in 'user_lastName', with: 'Doe'
		# 		fill_in 'user_phoneNumber', with: '1234567890'
		# 		select 'M', :from => 'user_tShirtSize'
		# 		fill_in 'user_participationPoints', with: 5
		# 		select 'Sophomore', :from => 'user_classification'
		# 		check 'user_optInEmail'
				
		# 		click_on 'Create User'
		# 		visit pendingApproval_path
		# 		expect(page).to have_content('John')
		# 	end
	
		# 	it 'is not valid with out points' do
		# 		visit new_user_path
				
		# 		fill_in 'user_email', with: 'featuretesting12@tamu.edu'
		# 		select 'Member', :from => 'user_role'
		# 		fill_in 'user_firstName', with: 'John'
		# 		fill_in 'user_lastName', with: 'Doe'
		# 		fill_in 'user_phoneNumber', with: '1234567890'
		# 		select 'M', :from => 'user_tShirtSize'
		# 		select 'Sophomore', :from => 'user_classification'
		# 		check 'user_optInEmail'
		# 		check 'user_approved'
		# 		click_on 'Create User'
		# 		visit users_path
		# 		sleep(1)
		# 		expect(page).to_not have_content('John')
		# 	end
	
		# 	it 'is not valid with negative points' do
		# 		visit new_user_path
				
		# 		fill_in 'user_email', with: 'featuretesting13@tamu.edu'
		# 		select 'Member', :from => 'user_role'
		# 		fill_in 'user_firstName', with: 'John'
		# 		fill_in 'user_lastName', with: 'Doe'
		# 		fill_in 'user_phoneNumber', with: '1234567890'
		# 		select 'M', :from => 'user_tShirtSize'
		# 		fill_in 'user_participationPoints', with: -5
		# 		select 'Sophomore', :from => 'user_classification'
		# 		check 'user_optInEmail'
		# 		check 'user_approved'
				
		# 		click_on 'Create User'
		# 		visit users_path
		# 		expect(page).to_not have_content('John')
		# 	end
	
		# 	it 'is valid with 0 points' do
		# 		visit new_user_path
				
		# 		fill_in 'user_email', with: 'featuretesting14@tamu.edu'
		# 		select 'Member', :from => 'user_role'
		# 		fill_in 'user_firstName', with: 'John'
		# 		fill_in 'user_lastName', with: 'Doe'
		# 		fill_in 'user_phoneNumber', with: '1234567890'
		# 		select 'M', :from => 'user_tShirtSize'
		# 		fill_in 'user_participationPoints', with: 0
		# 		select 'Sophomore', :from => 'user_classification'
		# 		check 'user_optInEmail'
		# 		check 'user_approved'
				
		# 		click_on 'Create User'
		# 		visit users_path
		# 		expect(page).to have_content('John')
		# 	end
		# end
		# describe 'Reading an existing user' do
		# 	it 'reads users correctly' do
		# 		user = User.create(email: 'featureRead@tamu.edu',
		# 					role: 0,
		# 					firstName: 'Feature',
		# 					lastName: 'Testing',
		# 					phoneNumber: '1231231234',
		# 					tShirtSize: 'M',
		# 					participationPoints: 5,
		# 					classification: 'Senior',
		# 					optInEmail: true,
		# 					approved: true,
		# 				)
		# 		visit users_path+'/'+user.id
		# 		expect(page).to have_content('Feature')
		# 		expect(page).to have_content('Testing')
		# 		expect(page).to have_content('(123)-123-1234')
		# 		expect(page).to have_content('M')
		# 		expect(page).to have_content('featureRead@tamu.edu')
		# 		expect(page).to have_content('Senior')
		# 		expect(page).to have_content('5')
		# 	end
		# end
	
		# describe 'Updating a user' do
		# 	it 'is valid with email change' do
		# 		user = User.create!(email: 'featureRead1@tamu.edu',
		# 			role: 0,
		# 			firstName: 'Feature',
		# 			lastName: 'Testing',
		# 			phoneNumber: '1231231234',
		# 			tShirtSize: 'M',
		# 			participationPoints: 5,
		# 			classification: 'Senior',
		# 			optInEmail: true,
		# 			approved: true
		# 		)
		# 		visit edit_user_path(id: user.id)
		# 		fill_in 'user_email', with: 'UpdatingTest@tamu.edu'
		# 		sleep(1)
		# 		click_on 'Update User'
		# 		sleep(1)
		# 		visit users_path
		# 		sleep(1)
		# 		expect(page).to have_content('UpdatingTest@tamu.edu')
		# 	end
	
		# 	it 'is not valid update with email change to nil' do
		# 		user = User.create!(email: 'featureRead1@tamu.edu',
		# 			role: 0,
		# 			firstName: 'Feature',
		# 			lastName: 'Testing',
		# 			phoneNumber: '1231231234',
		# 			tShirtSize: 'M',
		# 			participationPoints: 5,
		# 			classification: 'Senior',
		# 			optInEmail: true,
		# 			approved: true
		# 		)
		# 		visit edit_user_path(id: user.id)
		# 		fill_in 'user_email', with: ''
		# 		sleep(1)
		# 		click_on 'Update User'
		# 		sleep(1)
		# 		visit users_path
		# 		sleep(1)
		# 		expect(page).to have_content('featureRead1@tamu.edu')
		# 	end
	
		# 	it 'is valid with valid firstName change' do
		# 		user = User.create!(email: 'featureRead3@tamu.edu',
		# 			role: 0,
		# 			firstName: 'Feature',
		# 			lastName: 'Testing',
		# 			phoneNumber: '1231231234',
		# 			tShirtSize: 'M',
		# 			participationPoints: 5,
		# 			classification: 'Senior',
		# 			optInEmail: true,
		# 			approved: true
		# 		)
		# 		visit edit_user_path(id: user.id)
		# 		fill_in 'user_firstName', with: 'UpdatingTestFirst'
		# 		sleep(1)
		# 		click_on 'Update User'
		# 		sleep(1)
		# 		visit users_path
		# 		expect(page).to have_content('UpdatingTestFirst')
		# 	end
	
		# 	it 'is not valid with valid firstName change to nil' do
		# 		user = User.create!(email: 'featureRead4@tamu.edu',
		# 			role: 0,
		# 			firstName: 'Feature',
		# 			lastName: 'Testing',
		# 			phoneNumber: '1231231234',
		# 			tShirtSize: 'M',
		# 			participationPoints: 5,
		# 			classification: 'Senior',
		# 			optInEmail: true,
		# 			approved: true,
		# 		)
		# 		visit edit_user_path(id: user.id)
		# 		fill_in 'user_firstName', with: nil
		# 		sleep(1)
		# 		click_on 'Update User'
		# 		sleep(1)
		# 		visit users_path
		# 		sleep(1)
		# 		expect(page).to have_content('Feature')
		# 	end
	
		# 	it 'is valid with valid lastName change' do
		# 		user = User.create!(email: 'featureRead5@tamu.edu',
		# 			role: 0,
		# 			firstName: 'Feature',
		# 			lastName: 'Testing',
		# 			phoneNumber: '1231231234',
		# 			tShirtSize: 'M',
		# 			participationPoints: 5,
		# 			classification: 'Senior',
		# 			optInEmail: true,
		# 			approved: true,
		# 		)
		# 		visit edit_user_path(id: user.id)
		# 		fill_in 'user_lastName', with: 'UpdatingTestLast'
		# 		sleep(1)
		# 		click_on 'Update User'
		# 		sleep(1)
		# 		visit users_path
		# 		sleep(1)
		# 		expect(page).to have_content('UpdatingTestLast')
		# 	end
	
		# 	it 'is not valid with valid lastName change to nil' do
		# 		user = User.create!(email: 'featureRead6@tamu.edu',
		# 			role: 0,
		# 			firstName: 'Feature',
		# 			lastName: 'Testing',
		# 			phoneNumber: '1231231234',
		# 			tShirtSize: 'M',
		# 			participationPoints: 5,
		# 			classification: 'Senior',
		# 			optInEmail: true,
		# 			approved: true,
		# 		)
		# 		visit edit_user_path(id: user.id)
		# 		fill_in 'user_lastName', with: ""
		# 		sleep(1)
		# 		click_on 'Update User'
		# 		sleep(1)
		# 		visit users_path
		# 		sleep(1)
		# 		expect(page).to have_content('Testing')
		# 	end
	
		# 	it 'is valid with valid role change' do
		# 		user = User.create!(email: 'featureRead7@tamu.edu',
		# 			role: 0,
		# 			firstName: 'Feature',
		# 			lastName: 'Testing',
		# 			phoneNumber: '1231231234',
		# 			tShirtSize: 'M',
		# 			participationPoints: 5,
		# 			classification: 'Senior',
		# 			optInEmail: true,
		# 			approved: true,
		# 		)
		# 		visit edit_user_path(id: user.id)
		# 		sleep(2)
		# 		select 'Admin', :from => 'user_role'
		# 		sleep(1)
		# 		click_on 'Update User'
		# 		sleep(1)
		# 		visit users_path(id: user.id)
		# 		sleep(1)
		# 		expect(page).to have_content('Admin')
		# 	end
	
		# 	it 'is valid with valid phone number change' do
		# 		user = User.create!(email: 'featureRead8@tamu.edu',
		# 			role: 0,
		# 			firstName: 'Feature',
		# 			lastName: 'Testing',
		# 			phoneNumber: '1231231234',
		# 			tShirtSize: 'M',
		# 			participationPoints: 5,
		# 			classification: 'Senior',
		# 			optInEmail: true,
		# 			approved: true,
		# 		)
		# 		visit edit_user_path(id: user.id)
		# 		fill_in 'user_phoneNumber', with: '1231231235'
		# 		sleep(1)
		# 		click_on 'Update User'
		# 		sleep(1)
		# 		visit users_path
		# 		sleep(1)
		# 		expect(page).to have_content('(123)-123-1235')
		# 	end
	
		# 	it 'is not valid with phone number change less than 10 digits' do
		# 		user = User.create!(email: 'featureRead9@tamu.edu',
		# 			role: 0,
		# 			firstName: 'Feature',
		# 			lastName: 'Testing',
		# 			phoneNumber: '1231231234',
		# 			tShirtSize: 'M',
		# 			participationPoints: 5,
		# 			classification: 'Senior',
		# 			optInEmail: true,
		# 			approved: true,
		# 		)
		# 		visit edit_user_path(id: user.id)
		# 		fill_in 'user_phoneNumber', with: '12312312345'
		# 		sleep(1)
		# 		click_on 'Update User'
		# 		sleep(1)
		# 		visit users_path
		# 		sleep(1)
		# 		expect(page).to_not have_content('12312312345')
		# 	end
	
		# 	it 'is valid with valid classification change' do
		# 		user = User.create!(email: 'featureRead0@tamu.edu',
		# 			role: 0,
		# 			firstName: 'Feature',
		# 			lastName: 'Testing',
		# 			phoneNumber: '1231231234',
		# 			tShirtSize: 'M',
		# 			participationPoints: 5,
		# 			classification: 'Senior',
		# 			optInEmail: true,
		# 			approved: true,
		# 		)
		# 		visit edit_user_path(id: user.id)
		# 		select 'Junior', :from => 'user_classification'
		# 		sleep(1)
		# 		click_on 'Update User'
		# 		sleep(1)
		# 		visit users_path(id: user.id)
		# 		sleep(1)
		# 		expect(page).to have_content('Junior')
		# 	end
	
		# 	it 'is valid with valid tShirtSize change' do
		# 		user = User.create!(email: 'featureRead11@tamu.edu',
		# 			role: 0,
		# 			firstName: 'Feature',
		# 			lastName: 'Testing',
		# 			phoneNumber: '1231231234',
		# 			tShirtSize: 'M',
		# 			participationPoints: 5,
		# 			classification: 'Senior',
		# 			optInEmail: true,
		# 			approved: true,
		# 		)
		# 		visit edit_user_path(id: user.id)
		# 		sleep(1)
		# 		select 'XL', :from => 'user_tShirtSize'
		# 		sleep(1)
		# 		click_on 'Update User'
		# 		sleep(1)
		# 		visit users_path(id: user.id)
		# 		sleep(1)
		# 		expect(page).to have_content('XL')
		# 	end
	
		# 	it 'is valid with valid optInEmail change' do
		# 		user = User.create!(email: 'featureRead12@tamu.edu',
		# 			role: 0,
		# 			firstName: 'Feature',
		# 			lastName: 'Testing',
		# 			phoneNumber: '1231231234',
		# 			tShirtSize: 'M',
		# 			participationPoints: 5,
		# 			classification: 'Senior',
		# 			optInEmail: false,
		# 			approved: true,
		# 		)
		# 		visit edit_user_path(id: user.id)
		# 		sleep(1)
		# 		check 'user_optInEmail'
		# 		sleep(1)
		# 		click_on 'Update User'
		# 		sleep(1)
		# 		visit users_path(id: user.id)
		# 		sleep(1)
		# 		expect(page).to_not have_content('false')
		# 	end
	
		# 	it 'is valid with valid points change' do
		# 		user = User.create!(email: 'featureRead13@tamu.edu',
		# 			role: 0,
		# 			firstName: 'Feature',
		# 			lastName: 'Testing',
		# 			phoneNumber: '1231231234',
		# 			tShirtSize: 'M',
		# 			participationPoints: 5,
		# 			classification: 'Senior',
		# 			optInEmail: true,
		# 			approved: true,
		# 		)
		# 		visit edit_user_path(id: user.id)
		# 		sleep(1)
		# 		fill_in 'user_participationPoints', with: 15
		# 		sleep(1)
		# 		click_on 'Update User'
		# 		sleep(1)
		# 		visit users_path+'/'+user.id
		# 		sleep(1)
		# 		expect(page).to have_content('15')
		# 	end
	
		# 	it 'is not valid with points change to negative' do
		# 		user = User.create!(email: 'featureRead14@tamu.edu',
		# 			role: 0,
		# 			firstName: 'Feature',
		# 			lastName: 'Testing',
		# 			phoneNumber: '1231231234',
		# 			tShirtSize: 'M',
		# 			participationPoints: 5,
		# 			classification: 'Senior',
		# 			optInEmail: true,
		# 			approved: true,
		# 		)
		# 		visit edit_user_path(id: user.id)
		# 		sleep(1)
		# 		fill_in 'user_participationPoints', with: -15
		# 		sleep(1)
		# 		click_on 'Update User'
		# 		sleep(1)
		# 		visit users_path+'/'+user.id
		# 		sleep(1)
		# 		expect(page).to_not have_content('-15')
		# 	end
	
		# 	it 'is valid with valid approved change' do
		# 		user = User.create!(email: 'featureRead15@tamu.edu',
		# 			role: 0,
		# 			firstName: 'Feature',
		# 			lastName: 'Testing',
		# 			phoneNumber: '1231231234',
		# 			tShirtSize: 'M',
		# 			participationPoints: 5,
		# 			classification: 'Senior',
		# 			optInEmail: true,
		# 			approved: true,
		# 		)
		# 		visit edit_user_path(id: user.id)
		# 		sleep(1)
		# 		uncheck 'user_approved'
		# 		sleep(1)
		# 		click_on 'Update User'
		# 		sleep(1)
		# 		visit pendingApproval_path
		# 		sleep(1)
		# 		expect(page).to have_content('featureRead15@tamu.edu')
		# 	end
		# end
	
		describe 'Deleting a user' do
			it 'succeeded in deleting one user' do
				user = User.create!(email: 'featureRead16@tamu.edu',
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
				sleep(1)
				visit users_path 
				sleep(2)
				expect(page).to have_content('featureRead16@tamu.edu')
				visit user_path(id: user.id)
				sleep(3)
				click_button 'Destroy'
				sleep(3)
				page.driver.browser.switch_to.alert.accept
				
				# page.driver.browser.switch_to().alert.accept
				# page.driver.switchTo().alert().accept();
				sleep(2)
	
				visit users_path
				expect(page).to_not have_content('featureRead16@tamu.edu')
			end
	
			it 'succeeded in deleting 3 users' do
				user1 = User.create!(email: 'featureRead11@tamu.edu',
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
				user2 = User.create!(email: 'featureRead21@tamu.edu',
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
				user3 = User.create!(email: 'featureRead31@tamu.edu',
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
				sleep(4)
				visit users_path 
				sleep(3)
				expect(page).to have_content('featureRead11@tamu.edu')
				expect(page).to have_content('featureRead21@tamu.edu')
				expect(page).to have_content('featureRead31@tamu.edu')
	
				visit user_path(id: user1.id)
				click_button 'Destroy'
				sleep(4)
				page.driver.browser.switch_to.alert.accept
				sleep(3)
				
	
				visit user_path(id: user2.id)
				click_button 'Destroy'
				sleep(4)
				page.driver.browser.switch_to.alert.accept
				sleep(3)
	
				visit user_path(id: user3.id)
				click_button 'Destroy'
				sleep(4)
				page.driver.browser.switch_to.alert.accept
				sleep(3)
	
				visit users_path
				sleep(4)
				expect(page).to_not have_content('featureRead11@tamu.edu')
				expect(page).to_not have_content('featureRead21@tamu.edu')
				expect(page).to_not have_content('featureRead31@tamu.edu')
			end
		end
	
		describe "are trying to attend an event / point event." do
			event = Event.new
			pointEvent = PointEvent.new
	
			setup do
				event = Event.create!(name: 'Test Event',
							description: 'Test Description',
							points: 5,
							startDate: DateTime.now,
							endDate: DateTime.now + 1.week)
	
				pointEvent = PointEvent.create!(name: 'Test Event',
								description: 'Test Description',
								points: 5)
			end
	
			describe 'The users that have registered and are approved' do	
				it 'can attend an event' do
					visit attend_event_path(event)
					sleep(3)
					expect(page).to have_content('Test Event')
					expect(page).to have_content('Hello '+OmniAuth.config.mock_auth[:google_oauth2][:info][:email])
					click_link 'Click to attend!'
					sleep(4)
					expect(page).to have_content("Successfully attended Test Event!")
				end
	
				it 'cannot attend an event twice' do
					visit attend_event_path(event)
					sleep(3)
					expect(page).to have_content('Test Event')
					expect(page).to have_content('Hello '+OmniAuth.config.mock_auth[:google_oauth2][:info][:email])
	
					click_link 'Click to attend!'
					
					sleep(4)
					expect(page).to have_content("Successfully attended Test Event!")
	
					click_link 'Click to attend!'
					
					sleep(4)
					expect(page).to have_content('You have already attended Test Event!')
				end
	
				it 'can attend a point event' do
					visit attend_point_event_path(pointEvent)
					sleep(3)
					expect(page).to have_content('Test Event')
					expect(page).to have_content('Hello '+OmniAuth.config.mock_auth[:google_oauth2][:info][:email])
	
					click_on 'Click to attend!'
					sleep(4)
					expect(page).to have_content("Successfully attended Test Event!")
				end
	
				it 'cannot attend a point event twice' do
					visit attend_point_event_path(pointEvent)
					sleep(3)
					expect(page).to have_content('Test Event')
					expect(page).to have_content('Hello '+ OmniAuth.config.mock_auth[:google_oauth2][:info][:email])
	
					click_on 'Click to attend!'
					sleep(4)
					expect(page).to have_content("Successfully attended Test Event!")
	
					click_on 'Click to attend!'
					sleep(4)
					expect(page).to have_content('You have already attended Test Event!')
				end
			end
	
			describe 'The users that have registered but are not approved' do
				setup do
					visit edit_user_path(id: User.find_by(email:OmniAuth.config.mock_auth[:google_oauth2][:info][:email]).id)
					uncheck 'user_approved'
					sleep(2)
					click_on 'Update User'
					sleep(4)
				end
	
				it 'cannot attend an event' do
					sleep(1)
					visit attend_event_path(event)
					sleep(3)
					expect(page).to have_content('Test Event')
					expect(page).to have_content('Hello '+OmniAuth.config.mock_auth[:google_oauth2][:info][:email])
					
					click_on 'Click to attend!'
					sleep(4)
					expect(page).to have_content("Could not attend the event because "+OmniAuth.config.mock_auth[:google_oauth2][:info][:email]+" has not been approved by an administrator.")
				end
	
				it 'cannot attend a point event' do
					visit attend_point_event_path(pointEvent)
					sleep(3)
					expect(page).to have_content('Test Event')
					expect(page).to have_content('Hello '+OmniAuth.config.mock_auth[:google_oauth2][:info][:email])
					sleep(1)
					click_on 'Click to attend!'
					sleep(4)
					expect(page).to have_content("Could not attend the points event because "+OmniAuth.config.mock_auth[:google_oauth2][:info][:email]+" has not been approved by an administrator.")
				end
			end
	
			describe 'The users that are logged in devise but not in the user table' do
				setup do
					login_with_oauth_member_registration
				end
				it 'are asked to register first when trying to attend an event' do
					visit attend_event_path(event)
					sleep(2)
					expect(page).to have_content("Registration")
				end
	
				it 'are asked to register first when trying to attend a points event' do
					visit attend_point_event_path(pointEvent)
					sleep(2)
					expect(page).to have_content("Registration")
				end
			end
	
			describe 'The correct amount of points is displayed in the users dashboard.' do
				setup do
					visit edit_user_path(id: User.find_by(email:OmniAuth.config.mock_auth[:google_oauth2][:info][:email]).id)
					sleep(1)
					fill_in 'user_participationPoints', with: 5
					sleep(1)
					click_on 'Update User'
					sleep(1)
				end
	
				it 'A user with 5 points attends an event and point event for 5 points each has 15 points' do
					sleep(1)
					visit attend_event_path(event)
					sleep(3)
					click_link 'Click to attend!'
					sleep(4)
					visit attend_point_event_path(pointEvent)
					sleep(3)
					click_link 'Click to attend!'
					sleep(4)
					visit users_path+'/'+User.find_by(email:OmniAuth.config.mock_auth[:google_oauth2][:info][:email]).id
					sleep(4)
					expect(page).to have_content("15")
				end
	
				it 'A user with 5 points attends an event for 5 points and has 10 points' do
					visit attend_event_path(event)
					sleep(4)
					click_link 'Click to attend!'
					sleep(4)
					visit users_path+'/'+User.find_by(email:OmniAuth.config.mock_auth[:google_oauth2][:info][:email]).id
					sleep(4)
					expect(page).to have_content("10")
				end
			end
		end
	end
end

require 'rails_helper'

RSpec.describe 'Events', type: :feature do
	describe 'index page' do
		it 'shows the right content' do
			visit event_index_path
			#sleep(10)
			expect(page).to have_content('Events')
		end
	end
end

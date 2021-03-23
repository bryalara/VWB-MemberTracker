require 'rails_helper'

RSpec.describe 'EditHomePage', type: :feature do



     
     describe 'index page' do
          it 'shows the right content' do
               visit edithomepages_path
               sleep(10)
               expect(page).to have_content('name')
          end
     end
     
end
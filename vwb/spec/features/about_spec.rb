require 'rails_helper'

RSpec.describe 'Hello world', type: :system do
  describe 'index page' do
    it 'shows the right content' do
      visit 'home#index'
      click_on 'About'
      about = page.find_by_id('aboutH').text
      sleep(5)
      expect(about).to have_text('About Us')
    end
  end
end

require 'rails_helper'

RSpec.describe 'Hello world', type: :system do
  describe 'index page' do
    it 'shows the right content' do
      visit 'home#index'
      click_on 'Contact Us'
      contact = page.find_by_id('contactH').text
      sleep(5)
      expect(contact).to have_text('Contact Us!')
    end
  end
end

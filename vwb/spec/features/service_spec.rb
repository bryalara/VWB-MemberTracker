require 'rails_helper'

RSpec.describe 'Hello world', type: :system do
  describe 'index page' do
    it 'shows the right content' do
      visit 'home#index'
      click_on 'Service'
      service = page.find_by_id('serviceH').text
      sleep(5)
      expect(service).to have_text('Service')
    end
  end
end

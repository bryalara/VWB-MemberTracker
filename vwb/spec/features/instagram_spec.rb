require 'rails_helper'

RSpec.describe 'Hello world', type: :system do
  describe 'index page' do
    it 'redirects to instagram' do
      visit 'home#index'
      click_on 'Contact'
      sleep(5)
      expect(page).to have_selector(:css, 'a[href="https://www.instagram.com/vwbtamu/?hl=en"')
    end
  end
end

require 'rails_helper'

RSpec.describe 'Hello world', type: :system do
  describe 'index page' do
    it 'redirects to facebook' do
      visit 'home#index'
      click_on 'Contact'
      sleep(5)
      expect(page).to have_selector(:css, 'a[href="https://www.facebook.com/vwbtamu/"')
    end
  end
end

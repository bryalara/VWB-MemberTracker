require 'rails_helper'

RSpec.describe 'Hello world', type: :system do
  describe 'index page' do
    it 'shows the right title' do
      visit 'home#index'
      sleep(5)
      expect(page).to have_title('Veterinarians Without Borders')
    end
  end
end

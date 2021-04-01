# frozen_string_literal: true

require 'test_helper'

class RspecControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get rspec_index_url
    assert_response :success
  end
end

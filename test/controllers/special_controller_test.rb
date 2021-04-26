# frozen_string_literal: true

require 'test_helper'

class SpecialControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get special_index_url
    assert_response :success
  end
end

require 'test_helper'

class EdithomepagesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get edithomepages_index_url
    assert_response :success
  end

  test "should get show" do
    get edithomepages_show_url
    assert_response :success
  end

  test "should get new" do
    get edithomepages_new_url
    assert_response :success
  end

  test "should get edit" do
    get edithomepages_edit_url
    assert_response :success
  end

end

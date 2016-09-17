require 'test_helper'

class DataControllerTest < ActionController::TestCase
  test "should get shop_locations" do
    get :shop_locations
    assert_response :success
  end

end

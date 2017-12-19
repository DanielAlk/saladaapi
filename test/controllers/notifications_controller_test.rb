require 'test_helper'

class NotificationsControllerTest < ActionController::TestCase
  test "should get mercadopago" do
    get :mercadopago
    assert_response :success
  end

end

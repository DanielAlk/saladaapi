require 'test_helper'

class UserPhoneNumbersControllerTest < ActionController::TestCase
  setup do
    @user_phone_number = user_phone_numbers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_phone_numbers)
  end

  test "should create user_phone_number" do
    assert_difference('UserPhoneNumber.count') do
      post :create, user_phone_number: { phone_number: @user_phone_number.phone_number, user: @user_phone_number.user }
    end

    assert_response 201
  end

  test "should show user_phone_number" do
    get :show, id: @user_phone_number
    assert_response :success
  end

  test "should update user_phone_number" do
    put :update, id: @user_phone_number, user_phone_number: { phone_number: @user_phone_number.phone_number, user: @user_phone_number.user }
    assert_response 204
  end

  test "should destroy user_phone_number" do
    assert_difference('UserPhoneNumber.count', -1) do
      delete :destroy, id: @user_phone_number
    end

    assert_response 204
  end
end

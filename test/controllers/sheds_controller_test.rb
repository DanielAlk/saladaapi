require 'test_helper'

class ShedsControllerTest < ActionController::TestCase
  setup do
    @shed = sheds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sheds)
  end

  test "should create shed" do
    assert_difference('Shed.count') do
      post :create, shed: { title: @shed.title }
    end

    assert_response 201
  end

  test "should show shed" do
    get :show, id: @shed
    assert_response :success
  end

  test "should update shed" do
    put :update, id: @shed, shed: { title: @shed.title }
    assert_response 204
  end

  test "should destroy shed" do
    assert_difference('Shed.count', -1) do
      delete :destroy, id: @shed
    end

    assert_response 204
  end
end

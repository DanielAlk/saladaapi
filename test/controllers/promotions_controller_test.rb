require 'test_helper'

class PromotionsControllerTest < ActionController::TestCase
  setup do
    @promotion = promotions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:promotions)
  end

  test "should create promotion" do
    assert_difference('Promotion.count') do
      post :create, promotion: { description: @promotion.description, duration: @promotion.duration, duration_type: @promotion.duration_type, name: @promotion.title, title: @promotion.title, price: @promotion.price }
    end

    assert_response 201
  end

  test "should show promotion" do
    get :show, id: @promotion
    assert_response :success
  end

  test "should update promotion" do
    put :update, id: @promotion, promotion: { description: @promotion.description, duration: @promotion.duration, duration_type: @promotion.duration_type, name: @promotion.title, title: @promotion.title, price: @promotion.price }
    assert_response 204
  end

  test "should destroy promotion" do
    assert_difference('Promotion.count', -1) do
      delete :destroy, id: @promotion
    end

    assert_response 204
  end
end

require 'test_helper'

class ProductBuyClicksControllerTest < ActionController::TestCase
  setup do
    @product_buy_click = product_buy_clicks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:product_buy_clicks)
  end

  test "should create product_buy_click" do
    assert_difference('ProductBuyClick.count') do
      post :create, product_buy_click: { product_id: @product_buy_click.product_id, user_id: @product_buy_click.user_id }
    end

    assert_response 201
  end

  test "should show product_buy_click" do
    get :show, id: @product_buy_click
    assert_response :success
  end

  test "should update product_buy_click" do
    put :update, id: @product_buy_click, product_buy_click: { product_id: @product_buy_click.product_id, user_id: @product_buy_click.user_id }
    assert_response 204
  end

  test "should destroy product_buy_click" do
    assert_difference('ProductBuyClick.count', -1) do
      delete :destroy, id: @product_buy_click
    end

    assert_response 204
  end
end

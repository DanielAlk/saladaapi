require 'test_helper'

class ShopsControllerTest < ActionController::TestCase
  setup do
    @shop = shops(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:shops)
  end

  test "should create shop" do
    assert_difference('Shop.count') do
      post :create, shop: { location_floor: @shop.location_floor, location_row: @shop.location_row, gallery_name: @shop.gallery_name, category_id: @shop.category_id, fixed: @shop.fixed, image: @shop.image, letter_id: @shop.letter_id, location: @shop.location, location_detail: @shop.location_detail, number_id: @shop.number_id, opens: @shop.opens, shed_id: @shop.shed_id, status: @shop.status, user_id: @shop.user_id }
    end

    assert_response 201
  end

  test "should show shop" do
    get :show, id: @shop
    assert_response :success
  end

  test "should update shop" do
    put :update, id: @shop, shop: { location_floor: @shop.location_floor, location_row: @shop.location_row, gallery_name: @shop.gallery_name, category_id: @shop.category_id, fixed: @shop.fixed, image: @shop.image, letter_id: @shop.letter_id, location: @shop.location, location_detail: @shop.location_detail, number_id: @shop.number_id, opens: @shop.opens, shed_id: @shop.shed_id, status: @shop.status, user_id: @shop.user_id }
    assert_response 204
  end

  test "should destroy shop" do
    assert_difference('Shop.count', -1) do
      delete :destroy, id: @shop
    end

    assert_response 204
  end
end

require 'test_helper'

class AdsControllerTest < ActionController::TestCase
  setup do
    @ad = ads(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ads)
  end

  test "should create ad" do
    assert_difference('Ad.count') do
      post :create, ad: { actions: @ad.actions, cover: @ad.cover, kind: @ad.kind, special: @ad.special, status: @ad.status, text: @ad.text, title: @ad.title }
    end

    assert_response 201
  end

  test "should show ad" do
    get :show, id: @ad
    assert_response :success
  end

  test "should update ad" do
    put :update, id: @ad, ad: { actions: @ad.actions, cover: @ad.cover, kind: @ad.kind, special: @ad.special, status: @ad.status, text: @ad.text, title: @ad.title }
    assert_response 204
  end

  test "should destroy ad" do
    assert_difference('Ad.count', -1) do
      delete :destroy, id: @ad
    end

    assert_response 204
  end
end

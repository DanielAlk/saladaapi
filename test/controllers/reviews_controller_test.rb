require 'test_helper'

class ReviewsControllerTest < ActionController::TestCase
  setup do
    @review = reviews(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:reviews)
  end

  test "should create review" do
    assert_difference('Review.count') do
      post :create, review: { is_visible: @review.is_visible, product: @review.product, stars: @review.stars, text: @review.text, user: @review.user }
    end

    assert_response 201
  end

  test "should show review" do
    get :show, id: @review
    assert_response :success
  end

  test "should update review" do
    put :update, id: @review, review: { is_visible: @review.is_visible, product: @review.product, stars: @review.stars, text: @review.text, user: @review.user }
    assert_response 204
  end

  test "should destroy review" do
    assert_difference('Review.count', -1) do
      delete :destroy, id: @review
    end

    assert_response 204
  end
end

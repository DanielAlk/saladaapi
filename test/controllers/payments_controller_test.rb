require 'test_helper'

class PaymentsControllerTest < ActionController::TestCase
  setup do
    @payment = payments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:payments)
  end

  test "should create payment" do
    assert_difference('Payment.count') do
      post :create, payment: { collection_id: @payment.collection_id, collection_status: @payment.collection_status, collection_status_detail: @payment.collection_status_detail, init_point: @payment.init_point, mercadopago_preference: @payment.mercadopago_preference, payable_id: @payment.payable_id, payable_type: @payment.payable_type, payment_info: @payment.payment_info, payment_type: @payment.payment_type, preference_id: @payment.preference_id, transaction_amount: @payment.transaction_amount, user_id: @payment.user_id }
    end

    assert_response 201
  end

  test "should show payment" do
    get :show, id: @payment
    assert_response :success
  end

  test "should update payment" do
    put :update, id: @payment, payment: { collection_id: @payment.collection_id, collection_status: @payment.collection_status, collection_status_detail: @payment.collection_status_detail, init_point: @payment.init_point, mercadopago_preference: @payment.mercadopago_preference, payable_id: @payment.payable_id, payable_type: @payment.payable_type, payment_info: @payment.payment_info, payment_type: @payment.payment_type, preference_id: @payment.preference_id, transaction_amount: @payment.transaction_amount, user_id: @payment.user_id }
    assert_response 204
  end

  test "should destroy payment" do
    assert_difference('Payment.count', -1) do
      delete :destroy, id: @payment
    end

    assert_response 204
  end
end

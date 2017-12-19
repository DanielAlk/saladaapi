require 'test_helper'

class SubscriptionsControllerTest < ActionController::TestCase
  setup do
    @subscription = subscriptions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:subscriptions)
  end

  test "should create subscription" do
    assert_difference('Subscription.count') do
      post :create, subscription: { application_fee: @subscription.application_fee, charges_detail: @subscription.charges_detail, description: @subscription.description, end_date: @subscription.end_date, mercadopago_plan_id: @subscription.mercadopago_plan_id, mercadopago_subscription: @subscription.mercadopago_subscription, mercadopago_subscription_id: @subscription.mercadopago_subscription_id, metadata: @subscription.metadata, payer: @subscription.payer, plan: @subscription.plan, setup_fee: @subscription.setup_fee, start_date: @subscription.start_date, status: @subscription.status, user: @subscription.user }
    end

    assert_response 201
  end

  test "should show subscription" do
    get :show, id: @subscription
    assert_response :success
  end

  test "should update subscription" do
    put :update, id: @subscription, subscription: { application_fee: @subscription.application_fee, charges_detail: @subscription.charges_detail, description: @subscription.description, end_date: @subscription.end_date, mercadopago_plan_id: @subscription.mercadopago_plan_id, mercadopago_subscription: @subscription.mercadopago_subscription, mercadopago_subscription_id: @subscription.mercadopago_subscription_id, metadata: @subscription.metadata, payer: @subscription.payer, plan: @subscription.plan, setup_fee: @subscription.setup_fee, start_date: @subscription.start_date, status: @subscription.status, user: @subscription.user }
    assert_response 204
  end

  test "should destroy subscription" do
    assert_difference('Subscription.count', -1) do
      delete :destroy, id: @subscription
    end

    assert_response 204
  end
end

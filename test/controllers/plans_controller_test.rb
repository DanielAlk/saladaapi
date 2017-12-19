require 'test_helper'

class PlansControllerTest < ActionController::TestCase
  setup do
    @plan = plans(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:plans)
  end

  test "should create plan" do
    assert_difference('Plan.count') do
      post :create, plan: { application_fee: @plan.application_fee, auto_recurring: @plan.auto_recurring, description: @plan.description, mercadopago_plan: @plan.mercadopago_plan, mercadopago_plan_id: @plan.mercadopago_plan_id, metadata: @plan.metadata, status: @plan.status }
    end

    assert_response 201
  end

  test "should show plan" do
    get :show, id: @plan
    assert_response :success
  end

  test "should update plan" do
    put :update, id: @plan, plan: { application_fee: @plan.application_fee, auto_recurring: @plan.auto_recurring, description: @plan.description, mercadopago_plan: @plan.mercadopago_plan, mercadopago_plan_id: @plan.mercadopago_plan_id, metadata: @plan.metadata, status: @plan.status }
    assert_response 204
  end

  test "should destroy plan" do
    assert_difference('Plan.count', -1) do
      delete :destroy, id: @plan
    end

    assert_response 204
  end
end

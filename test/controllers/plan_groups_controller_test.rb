require 'test_helper'

class PlanGroupsControllerTest < ActionController::TestCase
  setup do
    @plan_group = plan_groups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:plan_groups)
  end

  test "should create plan_group" do
    assert_difference('PlanGroup.count') do
      post :create, plan_group: { description: @plan_group.description, name: @plan_group.name, starting_price: @plan_group.starting_price, subscriptable_role: @plan_group.subscriptable_role, title: @plan_group.title }
    end

    assert_response 201
  end

  test "should show plan_group" do
    get :show, id: @plan_group
    assert_response :success
  end

  test "should update plan_group" do
    put :update, id: @plan_group, plan_group: { description: @plan_group.description, name: @plan_group.name, starting_price: @plan_group.starting_price, subscriptable_role: @plan_group.subscriptable_role, title: @plan_group.title }
    assert_response 204
  end

  test "should destroy plan_group" do
    assert_difference('PlanGroup.count', -1) do
      delete :destroy, id: @plan_group
    end

    assert_response 204
  end
end

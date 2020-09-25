require 'test_helper'

class AdminNotificationsControllerTest < ActionController::TestCase
  setup do
    @admin_notification = admin_notifications(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_notifications)
  end

  test "should create admin_notification" do
    assert_difference('AdminNotification.count') do
      post :create, admin_notification: { alertable_id: @admin_notification.alertable_id, alertable_type: @admin_notification.alertable_type, kind: @admin_notification.kind, metadata: @admin_notification.metadata, status: @admin_notification.status }
    end

    assert_response 201
  end

  test "should show admin_notification" do
    get :show, id: @admin_notification
    assert_response :success
  end

  test "should update admin_notification" do
    put :update, id: @admin_notification, admin_notification: { alertable_id: @admin_notification.alertable_id, alertable_type: @admin_notification.alertable_type, kind: @admin_notification.kind, metadata: @admin_notification.metadata, status: @admin_notification.status }
    assert_response 204
  end

  test "should destroy admin_notification" do
    assert_difference('AdminNotification.count', -1) do
      delete :destroy, id: @admin_notification
    end

    assert_response 204
  end
end

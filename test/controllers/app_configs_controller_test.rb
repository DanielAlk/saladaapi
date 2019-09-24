require 'test_helper'

class AppConfigsControllerTest < ActionController::TestCase
  setup do
    @app_config = app_configs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:app_configs)
  end

  test "should create app_config" do
    assert_difference('AppConfig.count') do
      post :create, app_config: { content: @app_config.content, sid: @app_config.sid, title: @app_config.title }
    end

    assert_response 201
  end

  test "should show app_config" do
    get :show, id: @app_config
    assert_response :success
  end

  test "should update app_config" do
    put :update, id: @app_config, app_config: { content: @app_config.content, sid: @app_config.sid, title: @app_config.title }
    assert_response 204
  end

  test "should destroy app_config" do
    assert_difference('AppConfig.count', -1) do
      delete :destroy, id: @app_config
    end

    assert_response 204
  end
end

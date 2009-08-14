require 'test_helper'

class SettingsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:settings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create setting" do
    assert_difference('Setting.count') do
      post :create, :setting => { }
    end

    assert_redirected_to setting_path(assigns(:setting))
  end

  test "should show setting" do
    get :show, :id => settings(:team_name).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => settings(:team_name).to_param
    assert_response :success
  end

  test "should update setting" do
    put :update, :id => settings(:team_name).to_param, :setting => { }
    assert_redirected_to setting_path(assigns(:setting))
  end

  test "should destroy setting" do
    assert_difference('Setting.count', -1) do
      delete :destroy, :id => settings(:team_name).to_param
    end

    assert_redirected_to settings_path
  end
end

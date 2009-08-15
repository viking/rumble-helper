require 'test_helper'

class TeamsControllerTest < ActionController::TestCase
  setup do
    @data = fixture_data('team_data')
    Rumble.stubs(:team).with('team-shazbot').returns(@data)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create team" do

    assert_difference('Team.count') do
      post :create, :team => Factory.attributes_for(:team)
    end

    assert_redirected_to team_path
  end

  test "should show team" do
    get :show, :id => teams(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => teams(:one).to_param
    assert_response :success
  end

  test "should update team" do
    put :update, :id => teams(:one).to_param, :team => { }
    assert_redirected_to team_path
  end

  test "should destroy team" do
    assert_difference('Team.count', -1) do
      delete :destroy, :id => teams(:one).to_param
    end

    assert_redirected_to root_url
  end
end

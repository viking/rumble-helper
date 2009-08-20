require File.dirname(__FILE__) + '/../test_helper'

class TeamsControllerTest < ActionController::TestCase
  def setup
    activate_authlogic
    @team_data = fixture_data('team_data')
    Rumble.stubs(:team).returns(@team_data)

    @identity = fixture_data('identity')
    Rumble.stubs(:identity).returns(@identity)
  end

  test "should get new" do
    UserSession.create(Factory(:user))
    get :new
    assert_response :success
  end

  test "#new redirects to show if user's team exists" do
    team = Factory(:team)
    UserSession.create(Factory(:user))
    get :new
    assert_redirected_to team_url(team)
  end

  test "#new should require a user" do
    @controller.stubs(:current_user).returns(nil)
    get :new
    assert_redirected_to new_user_session_url
  end

  test "should create team, getting slug and api_key from current_user" do
    user = Factory(:user)
    UserSession.create(user)

    team = mock('team')
    Team.expects(:new).with({
      'slug' => user.team_slug, 'api_key' => user.api_key,
      'public' => '1'
    }).returns(team)
    team.expects(:save).returns(true)

    post :create, :team => { :public => '1' }
    assert_redirected_to new_task_url
  end

  test "#create redirects to show if user's team exists" do
    team = Factory(:team)
    UserSession.create(Factory(:user))
    assert_no_difference('Team.count') do
      post :create, :team => { :public => '1' }
    end
    assert_redirected_to team_url(team)
  end

  test "#create should require a user" do
    @controller.stubs(:current_user).returns(nil)
    post :create, :team => { :public => '1' }
    assert_redirected_to new_user_session_url
  end

  test "should show team" do
    team = Factory(:team)
    get :show, :id => team.to_param
    assert_response :success
    assert_equal team, assigns(:team)
  end

  test "should not show private team" do
    team = Factory(:team, :public => false)
    get :show, :id => team.to_param
    assert_response 404
  end

  test "should show current user's team, even if private" do
    team = Factory(:team, :public => false)
    UserSession.create(Factory(:user))
    get :show, :id => team.to_param
    assert_response :success
    assert_equal team, assigns(:team)
  end

  #test "should get edit" do
    #UserSession.create(Factory(:user))
    #get :edit, :id => @team.to_param
    #assert_response :success
  #end

  #test "should redirect from edit to login if not logged in" do
    #get :edit, :id => @team.to_param
    #assert_redirected_to new_user_session_url
  #end

  #test "should update team" do
    #UserSession.create(Factory(:user))
    #put :update, :team => { }
    #assert_redirected_to team_path
  #end

  #test "should redirect from update to login if not logged in" do
    #put :update, :team => { }
    #assert_redirected_to new_user_session_url
  #end
end

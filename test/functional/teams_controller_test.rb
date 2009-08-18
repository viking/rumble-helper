require 'test_helper'

class TeamsControllerTest < ActionController::TestCase
  def setup
    activate_authlogic
    @data = fixture_data('team_data')
    Rumble.stubs(:team).with('team-shazbot').returns(@data)
    @team = Factory(:team)
  end

  test "should get new" do
    Team.delete_all
    get :new
    assert_response :success
  end

  test "should redirect from new to show if team exists" do
    get :new
    assert_redirected_to 'team'
  end

  test "should create team" do
    Team.delete_all
    assert_difference('Team.count') do
      post :create, :team => Factory.attributes_for(:team)
    end
    assert_redirected_to new_account_url
  end

  test "should redirect from create to show if team exists" do
    assert_no_difference('Team.count') do
      post :create, :team => Factory.attributes_for(:team)
    end
    assert_redirected_to 'team'
  end

  test "should show team" do
    get :show
    assert_response :success
    assert_equal @team, assigns(:team)
    assert_equal Member.all, assigns(:members)
  end

  test "should redirect from show to new if no team" do
    Team.delete_all
    get :show
    assert_redirected_to 'team/new'
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

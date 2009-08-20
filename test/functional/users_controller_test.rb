require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    activate_authlogic
    @identity = fixture_data('identity')
    Rumble.stubs(:identity).returns(@identity)

    @team_data = fixture_data('team_data')
    Rumble.stubs(:team).returns(@team_data)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "#create should redirect to new_team_url if team doesn't exist" do
    user = mock('user', :team_slug => 'team-shazbot')
    user.expects(:save).yields(true)
    User.expects(:new).returns(user)
    post :create, :user => { :api_key => 'blahblah', :openid_identifier => "foo" }
    assert_redirected_to new_team_url
  end

  test "#create should set user's member if team exists" do
    team = Factory(:team)

    user = mock('user', :team_slug => 'team-shazbot')
    User.expects(:new).returns(user)
    user.expects(:save).yields(true)
    user.expects(:assign_to_member!)

    post :create, :user => { :api_key => 'blahblah', :openid_identifier => "foo" }
    assert_redirected_to root_url
  end

  test "should show user" do
    UserSession.create(Factory.create(:user))
    get :show
    assert_response :success
  end

  test "should get edit" do
    user = Factory.create(:user)
    UserSession.create(user)
    get :edit, :id => user.id
    assert_response :success
  end

  test "should update user" do
    user = Factory.create(:user)
    UserSession.create(user)
    put :update, :id => user.id, :user => { }
    assert_redirected_to account_path
  end
end

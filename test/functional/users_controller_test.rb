require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    setup :activate_authlogic
    @team = Factory(:team)
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_equal Member.all, assigns(:members)
  end

  test "should create user" do
    user = User.new
    user.expects(:save).yields(true)
    User.expects(:new).with('openid_identifier' => 'foo').returns(user)
    post :create, :user => { :openid_identifier => "foo" }
    assert_redirected_to root_url
  end

  test "should redirect to team_url if team is not set" do
    Team.delete_all

    user = User.new
    user.expects(:save).yields(true)
    User.expects(:new).returns(user)

    post :create, :user => { :openid_identifier => "https://me.yahoo.com/a/9W0FJjRj0o981TMSs0vqVxPdmMUVOQ--" }
    assert_redirected_to new_team_url
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

require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    activate_authlogic
    @team = Factory(:team)
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_equal Member.all, assigns(:members)
  end

  test "should display member_id instead of invitation_code if first user" do
    @controller.instance_variable_set("@current_user", nil)   # lame.
    User.delete_all
    get :new
    assert_select 'input[name=?]', "user[invitation_code]", false
    assert_select 'select[name=?]', "user[member_id]"
  end

  test "should display invitation_code instead of member_id if not first user" do
    @controller.instance_variable_set("@current_user", nil)   # lame.
    Factory(:user, :member => Member.first)
    get :new
    assert_select 'input[name=?]', "user[invitation_code]"
    assert_select 'select[name=?]', "user[member_id]", false
  end

  test "should redirect from new to root when all members are accounted for" do
    @controller.instance_variable_set("@current_user", nil)   # lame.

    Member.all.each { |m| Factory(:user, :member => m) }
    get :new
    assert_redirected_to root_url
  end

  test "should create user" do
    Factory(:task)
    user = User.new
    user.expects(:save).yields(true)
    User.expects(:new).with('openid_identifier' => 'foo').returns(user)
    post :create, :user => { :openid_identifier => "foo" }
    assert_redirected_to root_url
  end

  test "should redirect from create to members_url if this is the first user" do
    User.delete_all
    user = User.new
    user.expects(:save).yields(true)
    User.expects(:new).returns(user)
    User.expects(:count).returns(1)
    post :create, :user => { :openid_identifier => "https://me.yahoo.com/a/9W0FJjRj0o981TMSs0vqVxPdmMUVOQ--" }
    assert_redirected_to members_url
  end

  test "should redirect from create to root when all members are accounted for" do
    @controller.instance_variable_set("@current_user", nil)   # lame.

    Member.all.each { |m| Factory(:user, :member => m) }
    post :create, :user => { :openid_identifier => "https://me.yahoo.com/a/9W0FJjRj0o981TMSs0vqVxPdmMUVOQ--" }
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

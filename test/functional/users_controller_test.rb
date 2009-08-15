require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    setup :activate_authlogic
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    post :create, :user => { :openid_identifier => "https://me.yahoo.com/a/9W0FJjRj0o981TMSs0vqVxPdmMUVOQ--" }
    assert @response.redirected_to =~ /^https:\/\/open.login.yahooapis.com\/openid\/op\/auth/
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

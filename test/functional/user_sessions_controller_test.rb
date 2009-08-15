require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user session" do
    user = Factory.create(:user)
    post :create, :user_session => { :openid_identifier => "https://me.yahoo.com/a/9W0FJjRj0o981TMSs0vqVxPdmMUVOQ--" }
    assert @response.redirected_to =~ /^https:\/\/open.login.yahooapis.com\/openid\/op\/auth/
  end

  test "should destroy user session" do
    delete :destroy
    assert_nil UserSession.find
    assert_redirected_to new_user_session_path
  end
end

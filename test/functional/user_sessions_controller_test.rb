require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user session" do
    @controller.stubs(:current_user).returns(nil)
    user_session = mock
    user_session.expects(:save).yields(true)
    UserSession.expects(:new).with('openid_identifier' => "foo").returns(user_session)
    post :create, :user_session => { :openid_identifier => "foo" }
    assert_redirected_to root_url
  end

  test "should destroy user session" do
    delete :destroy
    assert_nil UserSession.find
    assert_redirected_to new_user_session_path
  end
end

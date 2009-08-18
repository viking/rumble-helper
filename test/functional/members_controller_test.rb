require 'test_helper'

class MembersControllerTest < ActionController::TestCase
  def setup
    activate_authlogic
    @member = Factory(:member)
  end

  test "should redirect from index to root" do
    get :index
    assert_redirected_to root_url
  end

  test "should render index when requesting xml" do
    get :index, :format => 'xml'
    assert_response :success
    assert_equal [@member].to_xml, @response.body
  end

  test "should redirect from show to root" do
    get :show, :id => @member.to_param
    assert_redirected_to root_url
  end

  test "should render show when requesting xml" do
    get :show, :id => @member.to_param, :format => 'xml'
    assert_response :success
    assert_equal @member.to_xml, @response.body
  end

  test "should update member" do
    UserSession.create(Factory(:user))
    put :update, :id => @member.to_param, :member => { }
    assert_redirected_to member_path(assigns(:member))
  end

  test "should redirect from update to login if not logged in" do
    put :update, :id => @member.to_param, :member => { }
    assert_redirected_to new_user_session_url
  end
end

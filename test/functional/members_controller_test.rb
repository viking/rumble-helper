require File.dirname(__FILE__) + '/../test_helper'

class MembersControllerTest < ActionController::TestCase
  def setup
    activate_authlogic

    @team_data = fixture_data('team_data')
    Rumble.stubs(:team).returns(@team_data)
    @identity = fixture_data('identity')
    Rumble.stubs(:identity).returns(@identity)

    @team = Factory(:team)
    @user = Factory(:user)
    @member = @team.members.first

    UserSession.create(@user)
  end

  test "should redirect from index to root_url" do
    get :index
    assert_redirected_to root_url
  end

  test "should render index when requesting xml" do
    not_your_member = Factory(:member)

    get :index, :format => 'xml'
    assert_response :success
    assert_equal @team.members.to_xml, @response.body
  end

  test "should redirect from index to login if not logged in" do
    UserSession.find.destroy
    get :index
    assert_redirected_to new_user_session_url
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

  test "should not show a member that isn't yours" do
    member = Factory(:member)

    get :show, :id => member.to_param, :format => 'xml'
    assert_response 404
  end

  test "should redirect from show to login if not logged in" do
    UserSession.find.destroy
    get :show, :id => @member.to_param
    assert_redirected_to new_user_session_url
  end

  test "should update member" do
    put :update, :id => @member.to_param, :member => { }
    assert_redirected_to root_url
  end

  test "should not set flash[:notice] for update for xml" do
    put :update, :format => 'xml', :id => @member.to_param, :member => { }
    assert_nil flash[:notice]
  end

  test "should not update a member that isn't yours" do
    member = Factory(:member)

    put :update, :id => member.to_param, :member => { }
    assert_response 404
  end

  test "should redirect from update to login if not logged in" do
    UserSession.find.destroy
    put :update, :id => @member.to_param, :member => { }
    assert_redirected_to new_user_session_url
  end
end

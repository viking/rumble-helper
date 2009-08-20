require 'test_helper'

class DashboardControllerTest < ActionController::TestCase
  def setup
    activate_authlogic
    @team_data = fixture_data('team_data')
    Rumble.stubs(:team).returns(@team_data)
    @team = Factory(:team)

    @identity = fixture_data('identity')
    Rumble.stubs(:identity).returns(@identity)
    @user = Factory(:user)

    UserSession.create(@user)
  end

  test "should render intro if not logged in" do
    UserSession.find.destroy
    get :index
    assert_template 'dashboard/intro'
  end

  test "should get index when logged in" do
    task_1 = Factory(:task, :status => 'in_progress', :team => @team)
    task_2 = Factory(:task, :team => @team)
    task_3 = Factory(:task, :status => 'done', :team => @team)
    not_your_task = Factory(:task)
    not_your_member = Factory(:member)

    get :index
    assert_template 'dashboard/index'
    assert_response :success
    assert_equal [task_2], assigns(:pending_tasks)
    assert_equal [task_3], assigns(:finished_tasks)
    assert_equal @team.members, assigns(:members)
    assert assigns(:auth_token)
  end

  test "should redirect to new_team_url if user doesn't have team" do
    @user.update_attribute(:team_id, nil)
    get :index
    assert_redirected_to new_team_url
  end

  test "should store location for index" do
    get :index
    assert_equal root_path, session[:return_to]
  end

  test "should render partial for index when ajax" do
    xhr :get, :index
    assert_template 'dashboard/_tasks'
  end
end

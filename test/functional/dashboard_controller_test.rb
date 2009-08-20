require 'test_helper'

class DashboardControllerTest < ActionController::TestCase
  def setup
    activate_authlogic
    @data = fixture_data('team_data')
    Rumble.stubs(:team).with('team-shazbot').returns(@data)
    @team = Factory(:team)
    @user = Factory(:user)
  end

  test "should render intro if not logged in" do
    @controller.instance_variable_set("@current_user", nil)   # lame.
    get :index
    assert_template 'dashboard/intro'
  end

  test "should get index when logged in" do
    UserSession.create(@user)
    task_1 = Factory(:task, :status => 'in_progress')
    task_2 = Factory(:task)
    task_3 = Factory(:task, :status => 'done')

    get :index
    assert_template 'dashboard/index'
    assert_response :success
    assert_equal [task_2], assigns(:pending_tasks)
    assert_equal [task_3], assigns(:finished_tasks)
    assert_equal Member.all, assigns(:members)
    assert assigns(:auth_token)
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

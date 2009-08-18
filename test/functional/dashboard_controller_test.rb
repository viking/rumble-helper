require 'test_helper'

class DashboardControllerTest < ActionController::TestCase
  def setup
    @data = fixture_data('team_data')
    Rumble.stubs(:team).with('team-shazbot').returns(@data)
    @team = Factory(:team)
    @user = Factory(:user)
  end

  test "should redirect to signup if no users" do
    User.delete_all
    get :index
    assert_redirected_to 'account/new'
  end

  test "should redirect to new_team_url if no users" do
    Team.delete_all
    get :index
    assert_redirected_to 'team/new'
  end

  test "should get index" do
    task_1 = Factory(:task, :status => 'in_progress')
    task_2 = Factory(:task)
    task_3 = Factory(:task, :status => 'done')

    get :index
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
end

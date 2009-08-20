require File.dirname(__FILE__) + '/../test_helper'

class TasksControllerTest < ActionController::TestCase
  def setup
    activate_authlogic

    @team_data = fixture_data('team_data')
    Rumble.stubs(:team).returns(@team_data)
    @identity = fixture_data('identity')
    Rumble.stubs(:identity).returns(@identity)

    @team = Factory(:team)
    @task = Factory(:task)
  end

  test "should get index" do
    get :index, :team_id => @team.to_param
    assert_response :success
    assert_not_nil assigns(:tasks)
  end

  test "#index finds only tasks related to team" do
    task = Factory(:task, :team_id => 123)
    get :index, :team_id => @team.to_param
    assert_equal [@task], assigns(:tasks)
  end

  test "should clear location for index" do
    session[:return_to] = '/yomamma'
    get :index, :team_id => @team.to_param
    assert_nil session[:return_to]
  end

  test "#index requires valid team id" do
    get :index, :team_id => 31337
    assert_response 404
  end

  test "#index requires public team" do
    @team.update_attribute(:public, false)
    get :index, :team_id => @team.to_param
    assert_response 404
  end

  test "should get new when logged in" do
    UserSession.create(Factory(:user))
    get :new, :team_id => @team.to_param
    assert_response :success
  end

  test "#new requires current user's team" do
    team = Factory(:team, :slug => 'pants')
    UserSession.create(Factory(:user))
    get :new, :team_id => team.to_param
    assert_response 404
  end

  test "should redirect from new to login if not logged in" do
    get :new, :team_id => @team.to_param
    assert_redirected_to new_user_session_url
  end

  test "should create task" do
    UserSession.create(Factory(:user))
    assert_difference('Task.count') do
      post :create, :team_id => @team.to_param, :task => Factory.attributes_for(:task)
    end

    assert_redirected_to team_tasks_url(@team)
  end

  test "should redirect after creating to new" do
    UserSession.create(Factory(:user))
    assert_difference('Task.count') do
      post(:create, {
        :team_id => @team.to_param,
        :commit => "Save and continue", :task => Factory.attributes_for(:task)
      })
    end

    assert_redirected_to new_team_task_url(@team)
  end

  test "should redirect from create to login if not logged in" do
    assert_no_difference('Task.count') do
      post(:create, {
        :team_id => @team.to_param,
        :task => Factory.attributes_for(:task)
      })
    end
    assert_redirected_to new_user_session_url
  end

  test "#create requires current user's team" do
    team = Factory(:team, :slug => 'pants')
    UserSession.create(Factory(:user))
    assert_no_difference('Task.count') do
      post(:create, {
        :team_id => team.to_param,
        :task => Factory.attributes_for(:task)
      })
    end
    assert_response 404
  end

  test "should redirect from show to index" do
    get :show, :team_id => @team.to_param, :id => @task.to_param
    assert_redirected_to team_tasks_url(@team)
  end

  test "should show task as xml" do
    get :show, :team_id => @team.to_param, :id => @task.to_param, :format => 'xml'
    assert_response :success
    assert_equal @task.to_xml, @response.body
  end

  test "should get edit" do
    UserSession.create(Factory(:user))
    get :edit, :team_id => @team.to_param, :id => @task.to_param
    assert_response :success
  end

  test "should redirect from edit to login if not logged in" do
    get :edit, :team_id => @team.to_param, :id => @task.to_param
    assert_redirected_to new_user_session_url
  end

  test "#edit requires current user's team" do
    team = Factory(:team, :slug => 'pants')
    UserSession.create(Factory(:user))
    get :edit, :team_id => team.to_param, :id => @task.to_param
    assert_response 404
  end

  test "should update task" do
    UserSession.create(Factory(:user))
    put :update, :team_id => @team.to_param, :id => @task.to_param, :task => { }
    assert_redirected_to team_tasks_url(@team)
  end

  test "should not set flash[:notice] for update for xml" do
    UserSession.create(Factory(:user))
    put :update, :team_id => @team.to_param, :format => 'xml', :id => @task.to_param, :task => { }
    assert_nil flash[:notice]
  end

  test "should return 404 if updating non-existant task" do
    UserSession.create(Factory(:user))
    put :update, :team_id => @team.to_param, :id => '8675309', :task => { }
    assert_response 404
  end

  test "should redirect from update to login if not logged in" do
    put :update, :team_id => @team.to_param, :id => @task.to_param, :task => { }
    assert_redirected_to new_user_session_url
  end

  test "#update requires current user's team" do
    team = Factory(:team, :slug => 'pants')
    UserSession.create(Factory(:user))
    put :update, :team_id => team.to_param, :id => @task.to_param, :task => { }
    assert_response 404
  end

  test "should destroy task" do
    UserSession.create(Factory(:user))
    assert_difference('Task.count', -1) do
      delete :destroy, :team_id => @team.to_param, :id => @task.to_param
    end

    assert_redirected_to team_tasks_url(@team)
  end

  test "should return 404 if destroying non-existant task" do
    UserSession.create(Factory(:user))
    delete :destroy, :team_id => @team.to_param, :id => '8675309'
    assert_response 404
  end

  test "should redirect from destroy to login if not logged in" do
    assert_no_difference('Task.count') do
      delete :destroy, :team_id => @team.to_param, :id => @task.to_param
    end
    assert_redirected_to new_user_session_url
  end

  test "#destroy requires current user's team" do
    team = Factory(:team, :slug => 'pants')
    UserSession.create(Factory(:user))
    assert_no_difference('Task.count') do
      delete :destroy, :team_id => team.to_param, :id => @task.to_param
    end
    assert_response 404
  end
end

require File.dirname(__FILE__) + '/../test_helper'

class TasksControllerTest < ActionController::TestCase
  def setup
    activate_authlogic

    @team_data = fixture_data('team_data')
    Rumble.stubs(:team).returns(@team_data)
    @identity = fixture_data('identity')
    Rumble.stubs(:identity).returns(@identity)

    @team = Factory(:team)
    @user = Factory(:user)
    @task = Factory(:task, :team => @team)

    UserSession.create(@user)
  end

  test "redirects to new_team_url if user has no team" do
    @team.destroy
    get :index
    assert_redirected_to new_team_url
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tasks)
  end

  test "#index finds only tasks related to user's team" do
    task = Factory(:task, :team_id => 123)
    get :index
    assert_equal [@task], assigns(:tasks)
  end

  test "should clear location for index" do
    session[:return_to] = '/yomamma'
    get :index
    assert_nil session[:return_to]
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should redirect from new to login if not logged in" do
    UserSession.find.destroy
    get :new
    assert_redirected_to new_user_session_url
  end

  test "should create task" do
    assert_difference('Task.count') do
      post :create, :task => Factory.attributes_for(:task)
    end

    assert_equal @team, assigns(:task).team
    assert_redirected_to tasks_url
  end

  test "should redirect after creating to new" do
    UserSession.create(Factory(:user))
    assert_difference('Task.count') do
      post(:create, {
        :commit => "Save and continue", :task => Factory.attributes_for(:task)
      })
    end

    assert_redirected_to new_task_url
  end

  test "should redirect from create to login if not logged in" do
    UserSession.find.destroy
    assert_no_difference('Task.count') do
      post(:create, { :task => Factory.attributes_for(:task) })
    end
    assert_redirected_to new_user_session_url
  end

  test "should redirect from show to index" do
    get :show, :id => @task.to_param
    assert_redirected_to tasks_url
  end

  test "should show task as xml" do
    get :show, :id => @task.to_param, :format => 'xml'
    assert_response :success
    assert_equal @task.to_xml, @response.body
  end

  test "should redirect from show to login if not logged in" do
    UserSession.find.destroy
    get :show, :id => @task.to_param
    assert_redirected_to new_user_session_url
  end

  test "should get edit" do
    get :edit, :id => @task.to_param
    assert_response :success
  end

  test "should redirect from edit to login if not logged in" do
    UserSession.find.destroy
    get :edit, :id => @task.to_param
    assert_redirected_to new_user_session_url
  end

  test "should update task" do
    put :update, :id => @task.to_param, :task => { }
    assert_redirected_to tasks_url
  end

  test "should not set flash[:notice] for update for xml" do
    put :update, :format => 'xml', :id => @task.to_param, :task => { }
    assert_nil flash[:notice]
  end

  test "should return 404 if updating non-existant task" do
    put :update, :id => '8675309', :task => { }
    assert_response 404
  end

  test "should redirect from update to login if not logged in" do
    UserSession.find.destroy
    put :update, :id => @task.to_param, :task => { }
    assert_redirected_to new_user_session_url
  end

  test "should destroy task" do
    assert_difference('Task.count', -1) do
      delete :destroy, :id => @task.to_param
    end

    assert_redirected_to tasks_url
  end

  test "should return 404 if destroying non-existant task" do
    delete :destroy, :id => '8675309'
    assert_response 404
  end

  test "should redirect from destroy to login if not logged in" do
    UserSession.find.destroy
    assert_no_difference('Task.count') do
      delete :destroy, :id => @task.to_param
    end
    assert_redirected_to new_user_session_url
  end
end

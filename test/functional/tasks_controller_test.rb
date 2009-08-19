require 'test_helper'

class TasksControllerTest < ActionController::TestCase
  def setup
    activate_authlogic
    @task = Factory.create(:task)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tasks)
  end

  test "should clear location for index" do
    session[:return_to] = '/yomamma'
    get :index
    assert_nil session[:return_to]
  end

  test "should get new when logged in" do
    UserSession.create(Factory(:user))
    get :new
    assert_response :success
  end

  test "should redirect from new to login if not logged in" do
    get :new
    assert_redirected_to new_user_session_url
  end

  test "should create task" do
    UserSession.create(Factory(:user))
    assert_difference('Task.count') do
      post :create, :task => Factory.attributes_for(:task)
    end

    assert_redirected_to tasks_path
  end

  test "should redirect after creating to new" do
    UserSession.create(Factory(:user))
    assert_difference('Task.count') do
      post :create, :commit => "Save and continue", :task => Factory.attributes_for(:task)
    end

    assert_redirected_to new_task_url
  end

  test "should redirect from create to login if not logged in" do
    assert_no_difference('Task.count') do
      post :create, :task => Factory.attributes_for(:task)
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

  test "should get edit" do
    UserSession.create(Factory(:user))
    get :edit, :id => @task.to_param
    assert_response :success
  end

  test "should redirect from edit to login if not logged in" do
    get :edit, :id => @task.to_param
    assert_redirected_to new_user_session_url
  end

  test "should update task" do
    UserSession.create(Factory(:user))
    put :update, :id => @task.to_param, :task => { }
    assert_redirected_to tasks_path
  end

  test "should not set flash[:notice] for update for xml" do
    UserSession.create(Factory(:user))
    put :update, :format => 'xml', :id => @task.to_param, :task => { }
    assert_nil flash[:notice]
  end

  test "should return 404 if updating non-existant task" do
    UserSession.create(Factory(:user))
    put :update, :id => '8675309', :task => { }
    assert_response 404
  end

  test "should redirect from update to login if not logged in" do
    put :update, :id => @task.to_param, :task => { }
    assert_redirected_to new_user_session_url
  end

  test "should destroy task" do
    UserSession.create(Factory(:user))
    assert_difference('Task.count', -1) do
      delete :destroy, :id => @task.to_param
    end

    assert_redirected_to tasks_path
  end

  test "should return 404 if destroying non-existant task" do
    UserSession.create(Factory(:user))
    delete :destroy, :id => '8675309'
    assert_response 404
  end

  test "should redirect from destroy to login if not logged in" do
    assert_no_difference('Task.count') do
      delete :destroy, :id => @task.to_param
    end
    assert_redirected_to new_user_session_url
  end

end

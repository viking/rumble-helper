require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "does not require email" do
    user = Factory.build(:user, :email => nil)
    assert user.valid?
  end

  test "requires 4 users or less" do
    4.times { Factory(:user) }
    user = Factory.build(:user)
    assert !user.valid?
  end

  test "belongs_to task" do
    task = Factory(:task)
    user = Factory(:user, :task => task)
    assert_equal task, user.task
  end

  test "activates task" do
    task = Factory(:task, :status => 'todo')
    user = Factory(:user)
    user.update_attribute(:task_id, task.id)
    assert_equal 'in_progress', user.task.status
  end

  test "stalls old task" do
    task_1 = Factory(:task)
    task_2 = Factory(:task)
    user = Factory(:user, :task => task_1)
    user.update_attribute(:task_id, task_2.id)
    assert_equal 'stalled', task_1.reload.status
  end

  test "#finish_task" do
    task = Factory(:task)
    user = Factory(:user, :task => task)
    user.finish_task!
    assert_equal 'done', task.reload.status
  end
end

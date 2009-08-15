require 'test_helper'

class MemberTest < ActiveSupport::TestCase
  test "belongs_to task" do
    task = Factory(:task)
    member = Factory(:member, :task => task)
    assert_equal task, member.task
  end

  test "activates task" do
    task = Factory(:task, :status => 'todo')
    member = Factory(:member)
    member.update_attribute(:task_id, task.id)
    assert_equal 'in_progress', member.task.status
  end

  test "stalls old task" do
    task_1 = Factory(:task)
    task_2 = Factory(:task)
    member = Factory(:member, :task => task_1)
    member.update_attribute(:task_id, task_2.id)
    assert_equal 'stalled', task_1.reload.status
  end

  test "#finish_task" do
    task = Factory(:task)
    member = Factory(:member, :task => task)
    member.finish_task!
    assert_equal 'done', task.reload.status
  end
end

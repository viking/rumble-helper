require 'test_helper'

class MemberTest < ActiveSupport::TestCase
  test "protects nickname from mass assignment" do
    member = Member.new(:nickname => 'foobar')
    assert_nil member.nickname
  end

  test "requires nickname" do
    member = Factory.build(:member, :nickname => nil)
    assert !member.valid?
  end

  test "belongs_to task" do
    task = Factory(:task)
    member = Factory(:member, :task => task)
    assert_equal task, member.task
  end

  test "has_one user" do
    member = Factory(:member)
    user = Factory(:user, :member => member)
    assert_equal user, member.user
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

  test "finishes old task when finish_task is true" do
    task = Factory(:task)
    member = Factory(:member, :task => task)
    member.update_attributes('task_id' => nil, 'finish_task' => true)
    assert_equal 'done', task.reload.status
  end

  test ".unassigned should find members that don't have users" do
    members = Array.new(4) { Factory(:member) }
    user = Factory(:user, :member => members.first)
    assert_equal members[1..-1], Member.unassigned
  end
end

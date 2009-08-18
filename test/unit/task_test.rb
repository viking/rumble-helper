require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  test "requires valid priority value" do
    task = Factory.build(:task)
    %w{Critical High Medium Low}.each do |value|
      task.priority = value
      assert task.valid?
    end
    task.priority = 'Crap'
    assert !task.valid?
  end

  test "requires valid status value" do
    task = Factory.build(:task)
    %w{todo in_progress stalled done}.each do |value|
      task.status = value
      assert task.valid?
    end
    task.status = 'crap4brains'
    assert !task.valid?
  end

  test "requires name" do
    task = Factory.build(:task, :name => nil)
    assert !task.valid?
  end

  test "has_many members" do
    task = Factory(:task)
    members = Factory(:member, :task => task)
    assert_equal [members], task.members
  end

  test "activation from todo" do
    task = Factory(:task, :status => 'todo')
    task.activate!
    assert_equal 'in_progress', task.reload.status
  end

  test "activation from stalled" do
    task = Factory(:task, :status => 'stalled')
    task.activate!
    assert_equal 'in_progress', task.status
  end

  test "activation from done" do
    task = Factory(:task, :status => 'done')
    task.activate!
    assert_equal 'in_progress', task.status
  end

  test "deactivation from in_progress" do
    task = Factory(:task, :status => 'in_progress')
    task.stall!
    assert_equal 'stalled', task.status
  end

  test "deactivation from done" do
    task = Factory(:task, :status => 'done')
    task.stall!
    assert_equal 'stalled', task.status
  end

  test "finishing task from in_progress" do
    task = Factory(:task, :status => 'in_progress')
    task.finish!
    assert_equal 'done', task.status
  end

  test "finishing task from todo" do
    task = Factory(:task, :status => 'todo')
    task.finish!
    assert_equal 'done', task.status
  end

  test "finishing task from stalled" do
    task = Factory(:task, :status => 'stalled')
    task.finish!
    assert_equal 'done', task.status
  end

  test "sets status_changed_at" do
    task = Factory(:task)
    assert task.status_changed_at
    assert (task.created_at - task.status_changed_at) < 1
  end

  test "should delete task_id from members on destroy" do
    task = Factory(:task)
    member = Factory(:member, :task => task)
    task.destroy
    assert_nil member.reload.task_id
  end
end

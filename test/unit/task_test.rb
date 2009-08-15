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

  test "has_many users" do
    task = Factory(:task)
    user = Factory(:user, :task => task)
    assert_equal [user], task.users
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

  test "deactivation from in_progress" do
    task = Factory(:task, :status => 'in_progress')
    task.stall!
    assert_equal 'stalled', task.status
  end

  test "finishing task from in_progress" do
    task = Factory(:task, :status => 'in_progress')
    task.finish!
    assert_equal 'done', task.status
  end
end

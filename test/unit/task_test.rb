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
    %w{To-do Started Stalled Done}.each do |value|
      task.status = value
      assert task.valid?
    end
    task.status = 'Crap'
    assert !task.valid?
  end

  test "has_many users" do
    task = Factory(:task)
    user = Factory(:user, :task => task)
    assert_equal [user], task.users
  end
end

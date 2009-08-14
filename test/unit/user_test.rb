require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "belongs_to task" do
    task = Factory(:task)
    user = Factory(:user, :task => task)
    assert_equal task, user.task
  end
end

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

  test "belongs_to member" do
    member = Factory(:member)
    user = Factory.build(:user, :member_id => member.id)
    assert_equal member, user.member
  end
end

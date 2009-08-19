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
    user = Factory.build(:user, :member => member)
    assert_equal member, user.member
  end

  test "doesn't require a member code if this is the first user" do
    User.delete_all
    user = Factory.build(:user, :invitation_code => nil)
    assert user.valid?
  end

  test "requires member_id if first user" do
    User.delete_all
    user = Factory.build(:user, :invitation_code => nil, :member => nil)
    assert !user.valid?
  end

  test "sets member from member_id instead of member code if first user" do
    User.delete_all
    member_1 = Factory(:member)
    member_2 = Factory(:member)
    user = Factory.build(:user, :member => nil, :invitation_code => member_2.invitation_code)
    user.member_id = member_1.id
    user.save
    assert_equal member_1, user.reload.member
  end

  test "validates presence of member code on create if second user" do
    first_user = Factory(:user)
    user = Factory.build(:user, :invitation_code => nil)
    assert !user.valid?
  end

  test "validates valid member code on create if second user" do
    first_user = Factory(:user)
    user = Factory.build(:user, :member => nil, :invitation_code => 'blahblah')
    assert !user.valid?
  end

  test "sets member from member code on create if second user" do
    first_user = Factory(:user)
    member = Factory(:member)
    user = Factory(:user, :member => nil, :invitation_code => member.invitation_code)
    assert_equal member, user.member
  end

  test "doesn't allow a registered member to be registered again" do
    first_user = Factory(:user)
    user = Factory.build(:user, :member => nil, :invitation_code => first_user.member.invitation_code)
    assert !user.valid?
  end

  test "gets nickname from member if none set" do
    member = Factory(:member)
    user = Factory(:user, :member => member, :nickname => nil)
    assert_equal member.nickname, user.nickname
  end
end

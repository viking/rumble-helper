require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @identity = fixture_data('identity')
    Rumble.stubs(:identity).returns(@identity)
  end

  test "does not require email" do
    user = Factory.build(:user, :email => nil)
    assert user.valid?
  end

  test "requires api_key" do
    user = Factory.build(:user, :api_key => nil)
    assert !user.valid?
  end

  test "requires valid api_key" do
    Rumble.stubs(:identity).returns(nil)
    user = Factory.build(:user, :api_key => 'blahblahblah')
    assert !user.valid?
  end

  test "requires user_type of 'participant'" do
    user = Factory.build(:user, :user_type => 'judge')
    assert !user.valid?
  end

  test "updates attributes from identity data" do
    user = Factory(:user)
    assert_equal "viking", user.nickname
    assert_equal "participant", user.user_type
    assert_equal "viking415@gmail.com", user.email
    assert_equal "team-shazbot", user.team_slug
    assert_equal "Team Shazbot", user.team_name
  end

  test '#assign_to_member! assigns member to user if team exists' do
    user = Factory(:user)

    team_data = fixture_data('team_data')
    Rumble.stubs(:team).returns(team_data)
    team = Factory(:team)

    user.assign_to_member!
    assert_equal user.nickname, user.member.nickname
    assert_equal team, user.team
  end

end

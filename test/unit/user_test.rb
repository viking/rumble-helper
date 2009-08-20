require File.dirname(__FILE__) + '/../test_helper'

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

  test "requires that api_key is a hex code" do
    user = Factory.build(:user, :api_key => "omgblah!!!")
    assert !user.valid?
  end

  test "requires api_key that checks out with the rumble site" do
    Rumble.stubs(:identity).returns({'hash'=>{'error'=>'You are not logged in'}})
    user = Factory.build(:user, :api_key => 'abc123')
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
    assert_equal 3, user.team_rumble_id
  end

  test "is invalid if rumble data is bogus" do
    Rumble.stubs(:identity).returns({'hash' => {'crapforcrap' => 'blahblah'}})
    user = Factory.build(:user)
    assert !user.valid?
  end

  test "is invalid when server is down" do
    Rumble.stubs(:identity).raises(SocketError)
    user = Factory.build(:user)
    assert !user.valid?
  end

  test "is invalid if data is missing" do
    @identity['hash']['details']['nickname'] = nil
    user = Factory.build(:user)
    assert !user.valid?
  end

  test "automatically assigns team_id if team with same rumble_id is found" do
    team_data = fixture_data('team_data')
    Rumble.stubs(:team).returns(team_data)

    team = Factory(:team)
    user = Factory(:user)
    assert_equal team.id, user.reload.team_id
  end
end

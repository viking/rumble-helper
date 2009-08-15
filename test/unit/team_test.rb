require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  def setup
    @data = fixture_data('team_data')
    Rumble.stubs(:team).returns(@data)
  end

  test "requires slug" do
    team = Factory.build(:team, :slug => nil)
    assert !team.valid?
  end

  test "updates name from team data" do
    team = Factory(:team, :slug => 'your-mom')
    assert_equal "Team Shazbot", team.name
  end

  test "fails validation on failed fetch" do
    Rumble.stubs(:team).returns(nil)
    team = Factory.build(:team)
    assert !team.valid?
  end

  test "creates members from team data" do
    assert_equal 0, Member.count
    team = Factory(:team)
    assert !team.new_record?
    assert_equal 3, Member.count
  end
end

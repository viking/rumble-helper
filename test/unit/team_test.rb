require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  def setup
    activate_authlogic
    @team_data = fixture_data('team_data')
    Rumble.stubs(:team).returns(@team_data)
    @identity = fixture_data('identity')
    Rumble.stubs(:identity).returns(@identity)
  end

  test "requires slug" do
    team = Factory.build(:team, :slug => nil)
    assert !team.valid?
  end

  test "updates attributes from team data" do
    Rumble.expects(:team).with('your-mom').returns(@team_data)

    team = Factory(:team, :slug => 'your-mom')
    assert_equal "Team Shazbot", team.name
    assert_equal "lend.to", team.app_name
    assert_equal "A web app to keep track of stuff you've let your friends borrow.", team.app_description
    assert_equal "http://shazbot.r09.railsrumble.com", team.app_url
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
    assert_equal 4, Member.count
    assert_equal Member.all, team.members
  end

  test "initial status of shiny" do
    team = Factory(:team)
    assert_equal 'shiny', team.status
  end

  test "transitions from shiny to dull on update" do
    team = Factory(:team)
    team.save
    assert_equal 'dull', team.status
  end

  test "has_many users through members" do
    identity = fixture_data('identity')
    Rumble.stubs(:identity).returns(identity)
    user = Factory(:user)

    team = Factory(:team)

    team.members.find_by_nickname('viking').update_attribute(:user_id, user.id)
    assert team.users.include?(user)
  end

  test "has_many tasks" do
    team = Factory(:team)
    task = Factory(:task, :team => team)
    assert_equal [task], team.tasks
  end

  #test ".public_or_current finds only public or current_user's team" do
    #UserSession.create(Factory(:user))
    #team_1 = Factory(:team, :slug => 'ninja-fu')
    #team_2 = Factory(:team, :slug => 'ninja-poo', :public => false)
    #team_3 = Factory(:team, :public => false)

    #assert [team_1, team_3], Team.public_or_current
  #end
end

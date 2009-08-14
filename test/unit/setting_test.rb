require 'test_helper'

class SettingTest < ActiveSupport::TestCase
  test ".[:team_name] returns team_name" do
    assert_equal 'Team Shazbot', Setting[:team_name]
  end

  test ".[:team_name] returns default value" do
    Setting.delete_all
    assert_equal 'Our Rumble Team', Setting[:team_name]
  end
end

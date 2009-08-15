require 'test_helper'

class RumbleTest < ActiveSupport::TestCase
  test "includes HTTParty" do
    assert Rumble.included_modules.include?(HTTParty)
  end

  test "base_uri is correct" do
    assert_equal "http://r09.railsrumble.com", Rumble.base_uri
  end

  test ".team fetches team by slug" do
    data = fixture_data('team_data')
    Rumble.expects(:get).with('/teams/team-shazbot.xml').returns(data)
    assert_equal data, Rumble.team('team-shazbot')
  end

  test ".team returns nil on 404" do
    Rumble.expects(:get).with('/teams/team-shazbot.xml').returns("404 page")
    assert_equal nil, Rumble.team('team-shazbot')
  end
end

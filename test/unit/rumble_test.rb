require 'test_helper'

class RumbleTest < ActiveSupport::TestCase
  test "includes HTTParty" do
    assert Rumble.included_modules.include?(HTTParty)
  end

  test "base_uri is correct" do
    assert_equal "http://r09.railsrumble.com", Rumble.base_uri
  end

  test ".identity fetches user by api_key" do
    data = fixture_data('identity')
    Rumble.expects(:get).with('/users/identity.xml?api_key=abc123def456').returns(data)
    assert_equal data, Rumble.identity('abc123def456')
  end

  test ".identity returns nil on 404" do
    data = { 'error' => 'You are not logged in' }
    Rumble.expects(:get).with('/users/identity.xml?api_key=abc123def456').returns(data)
    assert_nil Rumble.identity('abc123def456')
  end

  test ".team fetches team by slug and api-key" do
    data = fixture_data('team_data')
    Rumble.expects(:get).with('/teams/team-shazbot.xml?api_key=abc123def456').returns(data)
    assert_equal data, Rumble.team('team-shazbot', 'abc123def456')
  end

  test ".team returns nil on 404" do
    Rumble.expects(:get).with('/teams/team-shazbot.xml?api_key=abc123def456').returns("404 page")
    assert_nil Rumble.team('team-shazbot', 'abc123def456')
  end
end

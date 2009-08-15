class Rumble
  include HTTParty
  base_uri "http://r09.railsrumble.com"

  def self.team(slug)
    result = get("/teams/#{slug}.xml")
    result.is_a?(Hash) ? result : nil
  end
end

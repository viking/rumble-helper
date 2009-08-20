class Rumble
  include HTTParty
  base_uri "http://r09.railsrumble.com"

  def self.identity(api_key)
    get("/users/identity.xml?api_key=#{api_key}")
  end

  def self.team(slug, api_key)
    get("/teams/#{slug}.xml?api_key=#{api_key}")
  end
end

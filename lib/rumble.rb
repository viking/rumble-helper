class Rumble
  include HTTParty
  base_uri "http://r09.railsrumble.com"

  def self.identity(api_key)
    result = get("/users/identity.xml?api_key=#{api_key}")
    if result.is_a?(Hash)
      result['error'] ? nil : result
    else
      nil
    end
  end

  def self.team(slug)
    result = get("/teams/#{slug}.xml")
    result.is_a?(Hash) ? result : nil
  end
end

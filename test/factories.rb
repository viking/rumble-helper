Factory.define :user do |u|
  u.nickname { Forgery(:internet).user_name }
  u.email { |user| Forgery(:internet).email_address }
  u.api_key { Authlogic::Random.hex_token }
end

Factory.define :task do |t|
  t.name { %w{Huge Large Medium Small}.random }
  t.priority { %w{Critical High Medium Low}.random }
  t.description { Forgery(:lorem_ipsum).sentence }
  t.team_id 123
end

Factory.define :team do |t|
  t.slug "team-shazbot"
  t.public true
  t.api_key { Authlogic::Random.hex_token }
end

Factory.define :member do |m|
  m.nickname { Forgery(:internet).user_name }
end

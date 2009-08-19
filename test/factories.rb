Factory.define :user do |u|
  u.nickname { Forgery(:internet).user_name }
  u.email { |user| Forgery(:internet).email_address }
  u.association :member
  u.invitation_code { |user| user.member.invitation_code }
end

Factory.define :task do |t|
  t.name { %w{Huge Large Medium Small}.random }
  t.priority { %w{Critical High Medium Low}.random }
  t.description { Forgery(:lorem_ipsum).sentence }
end

Factory.define :team do |t|
  t.slug "team-shazbot"
end

Factory.define :member do |m|
  m.nickname { Forgery(:internet).user_name }
end

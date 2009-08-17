Factory.define :user do |f|
  f.nickname { Forgery(:internet).user_name }
  f.email { |u| u.nickname + '@' + Forgery(:internet).domain_name }
end

Factory.define :task do |t|
  t.priority { %w{Critical High Medium Low}.random }
  t.description { Forgery(:lorem_ipsum).sentence }
end

Factory.define :team do |t|
  t.slug "team-shazbot"
end

Factory.define :member do |m|
  m.nickname { Forgery(:internet).user_name }
end

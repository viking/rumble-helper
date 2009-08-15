Factory.define :user do |f|
  f.nickname { Forgery(:internet).user_name }
  f.email { |u| u.nickname + '@' + Forgery(:internet).domain_name }
end

Factory.define :task do |t|
  t.priority { %w{Critical High Medium Low}.random }
end

Factory.define :team do |t|
  t.slug "team-shazbot"
end

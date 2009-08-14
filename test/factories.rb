Factory.define :user do |f|
  f.login { Forgery(:internet).user_name }
  f.email { |u| u.login + '@' + Forgery(:internet).domain_name }
  f.password 'secret'
  f.password_confirmation 'secret'
end

Factory.define :task do |t|
  t.priority { %w{Critical High Medium Low}.random }
  t.status { %w{To-do Started Stalled Done}.random }
end

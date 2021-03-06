# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090820195813) do

  create_table "members", :force => true do |t|
    t.string   "nickname"
    t.integer  "team_id"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "open_id_authentication_associations", :force => true do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.integer "timestamp",  :null => false
    t.string  "server_url"
    t.string  "salt",       :null => false
  end

  create_table "tasks", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "priority"
    t.string   "status"
    t.datetime "status_changed_at"
    t.integer  "total_effort_spent"
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", :force => true do |t|
    t.integer  "rumble_id"
    t.string   "slug"
    t.string   "name"
    t.text     "app_description", :limit => 255
    t.string   "app_name"
    t.string   "app_url"
    t.string   "status"
    t.boolean  "public"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "persistence_token"
    t.integer  "login_count"
    t.integer  "failed_login_count"
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.string   "perishable_token",   :default => "", :null => false
    t.string   "nickname"
    t.string   "email"
    t.string   "user_type"
    t.string   "openid_identifier"
    t.string   "api_key"
    t.integer  "team_id"
    t.integer  "team_rumble_id"
    t.string   "team_slug"
    t.string   "team_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["openid_identifier"], :name => "index_users_on_openid_identifier"

end

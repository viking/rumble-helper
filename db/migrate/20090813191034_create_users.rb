class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :nickname
      t.string :email
      t.string :persistence_token
      t.integer :login_count
      t.integer :failed_login_count
      t.datetime :last_request_at
      t.datetime :current_login_at
      t.datetime :last_login_at
      t.string :current_login_ip
      t.string :last_login_ip
      t.string :perishable_token, :default => "", :null => false
      t.string :openid_identifier
      t.integer :task_id

      t.timestamps
    end
    add_index :users, :openid_identifier
  end

  def self.down
    drop_table :users
  end
end

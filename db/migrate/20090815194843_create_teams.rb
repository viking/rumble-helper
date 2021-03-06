class CreateTeams < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.integer :rumble_id
      t.string :slug
      t.string :name
      t.string :app_description
      t.string :app_name
      t.string :app_url
      t.string :status
      t.boolean :public

      t.timestamps
    end
  end

  def self.down
    drop_table :teams
  end
end

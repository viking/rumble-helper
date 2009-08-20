class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.string :name
      t.string :description
      t.string :priority
      t.string :status
      t.datetime :status_changed_at
      t.integer :total_effort_spent
      t.integer :team_id

      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end

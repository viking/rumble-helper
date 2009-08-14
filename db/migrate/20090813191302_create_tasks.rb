class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.string :name
      t.string :priority
      t.string :status
      t.string :person

      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
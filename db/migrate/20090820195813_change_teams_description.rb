class ChangeTeamsDescription < ActiveRecord::Migration
  def self.up
    change_column :teams, :app_description, :text
  end

  def self.down
    change_column :teams, :app_description, :string
  end
end

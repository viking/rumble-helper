class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.string :name
      t.string :value

      t.timestamps
    end
    Setting.create(:name => 'team_name', :value => 'Our Rumble Team')
  end

  def self.down
    drop_table :settings
  end
end

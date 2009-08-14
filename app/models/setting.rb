class Setting < ActiveRecord::Base
  DEFAULTS = {
    'team_name' => 'Our Rumble Team'
  }

  def self.[](name)
    setting = find_by_name(name.to_s)
    setting ? setting.value : DEFAULTS[name.to_s]
  end
end

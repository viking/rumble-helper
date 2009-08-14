class Task < ActiveRecord::Base
  PRIORITIES = %w{Critical High Medium Low}
  STATUSES = %w{To-do Started Stalled Done}

  has_many :users

  validates_inclusion_of :priority, :in => PRIORITIES
  validates_inclusion_of :status, :in => STATUSES
end

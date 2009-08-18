class Task < ActiveRecord::Base
  PRIORITIES = %w{Critical High Medium Low}
  STATUSES   = %w{todo in_progress stalled done}

  include AASM
  aasm_column :status
  STATUSES.each_with_index do |status, i|
    aasm_initial_state(status.to_sym)  if i == 0
    aasm_state(status.to_sym)
  end

  aasm_event :activate do
    transitions :to => :in_progress, :from => [:todo, :stalled, :done]
  end
  aasm_event :stall do
    transitions :to => :stalled, :from => [:in_progress, :done]
  end
  aasm_event :finish do
    transitions :to => :done, :from => [:in_progress, :stalled, :todo]
  end

  has_many :members, :dependent => :nullify

  validates_presence_of :name
  validates_inclusion_of :priority, :in => PRIORITIES
  validates_inclusion_of :status, :in => STATUSES

  named_scope :finished, :conditions => { :status => 'done' }
  named_scope :pending, :conditions => "status IN ('todo', 'stalled')"

  before_save :set_status_changed_at

  private
    def set_status_changed_at
      if status_changed?
        self.status_changed_at = Time.now
      end
    end
end

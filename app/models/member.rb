class Member < ActiveRecord::Base
  attr_accessor :finish_task, :move_task_from_member
  attr_protected :nickname

  validates_presence_of :nickname

  belongs_to :task
  has_one :user

  before_save :remember_task
  after_save :update_task

  named_scope(:unassigned, {
    :joins => "LEFT JOIN users ON members.id = users.member_id",
    :conditions => "users.member_id IS NULL"
  })

  private
    def remember_task
      if @move_task_from_member
        other = Member.find(@move_task_from_member)
        self.task_id = other.task_id
        other.update_attribute(:task_id, nil)
      end

      if task_id_changed? && task_id_was
        @previous_task_id = task_id_was
      else
        @previous_task_id = :unchanged
      end
    end

    def update_task
      current_task = self.task(true)
      if current_task && current_task.status != 'in_progress'
        current_task.activate!
      end
      if @previous_task_id && @previous_task_id != :unchanged
        previous_task = Task.find(@previous_task_id)
        if @move_task_to_member
          previous_task.update_attribute('status_changed_at', Time.now)
          @move_task_to_member = nil
        elsif @finish_task
          previous_task.finish!
          @finish_task = false
        else
          previous_task.stall!
        end
      end
    end
end

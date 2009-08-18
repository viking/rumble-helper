class Member < ActiveRecord::Base
  attr_accessor :finish_task
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
      if task_id_changed? && task_id_was
        @previous_task_id = task_id_was
      else
        @previous_task_id = :unchanged
      end
    end

    def update_task
      current_task = self.task(true)
      current_task.activate!  if current_task
      if @previous_task_id && @previous_task_id != :unchanged
        previous_task = Task.find(@previous_task_id)
        if @finish_task
          previous_task.finish!
        else
          previous_task.stall!
        end
      end
      @finish_task = false
    end
end

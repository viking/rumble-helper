class Member < ActiveRecord::Base
  attr_accessor :finish_task

  belongs_to :task
  before_save :remember_task
  after_save :update_task

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

module DashboardHelper
  def task_bubble(task)
    klass = "task #{task.priority.downcase} #{task.status}"
    klass << " draggable"   unless task.status == "done"
    content_tag('div', task.name, :id => "task_#{task.id}", :class => klass)
  end
end

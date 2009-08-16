module DashboardHelper
  def task_bubble(task)
    content_tag('div', task.name, {
      :id => "task_#{task.id}",
      :class => "task #{task.priority.downcase} draggable #{task.status}"
    })
  end
end

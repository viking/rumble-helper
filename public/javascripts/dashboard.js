$(function() {
  tasks_url = $('#tasks_url').html();
  members_url = $('#members_url').html();
  auth_token = $('#auth_token').html();

  $('.draggable').draggable();
  $('.member.droppable').droppable({
    accept: '.todo, .stalled',
    drop: function(event, ui) {
      obj = ui.draggable.clone().attr('style', '');
      status = null;

      $(this).find('.current_task').html(obj);
      obj.draggable();
      ui.draggable.remove();

      pending = $('#pending_tasks');
      if (pending.find('.task').length == 0) {
        obj.removeClass('todo').removeClass('stalled').addClass('in_progress');
        pending.prepend("You did everything?  Yeah right.  Better <a href='"+tasks_url+"/new'>add another task</a>.");
      }

      // update task
      member_id = $(this).attr('id').substring(7);
      task_id = obj.attr('id').substring(5);
      $.ajax({
        type: 'POST',
        data: {
          'member[task_id]': task_id,
          'authenticity_token': auth_token,
          '_method': 'put'
        },
        url: members_url+'/'+member_id
      });
    }
  });
});

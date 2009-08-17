(function($) {
  $.rumblehelper = {};

  $.rumblehelper.dashboard = {
    options: {},

    init: function() {
      $.extend(this.options, {
        tasks_url: $('#tasks_url').html(),
        members_url: $('#members_url').html(),
        auth_token: $('#auth_token').html()
      });
      $('.draggable').draggable();
      $('.member').droppable(this.member_droppable_options).each(function() {
        obj = $(this);
        if (obj.find('.task').length == 1) {
          obj.droppable('disable');
        }
      });
      $('#pending_tasks').droppable(this.pending_droppable_options);
    },

    member_droppable_options: {
      accept: '.todo, .stalled',
      drop: function(event, ui) {
        task_id = ui.draggable.attr('id').substring(5);
        $.rumblehelper.dashboard.move_draggable(ui.draggable, this);

        // update member
        member_id = $(this).attr('id').substring(7);
        $.rumblehelper.dashboard.update_member(member_id, task_id);

        $(this).droppable('disable');
      }
    },

    pending_droppable_options: {
      accept: '.in_progress',
      drop: function(event, ui) {
        member_id = ui.draggable.parents('.member').attr('id').substring(7);
        $.rumblehelper.dashboard.move_draggable(ui.draggable, this);

        // update member
        $.rumblehelper.dashboard.update_member(member_id, '');
      }
    },

    move_draggable: function(draggable, destination) {
      source = draggable.parent();

      new_obj = draggable.clone().attr('style', '');
      tasks = $(destination).find('.tasks')
      if (tasks.find('.task').length == 0) {
        tasks.html(new_obj);
      }
      else {
        tasks.append(new_obj);
      }
      new_obj.draggable();
      draggable.remove();

      if (new_obj.hasClass('todo') || new_obj.hasClass('stalled')) {
        new_obj.removeClass('todo').removeClass('stalled').addClass('in_progress');
        this.update_pending_tasks(source);
      }
      else if (new_obj.hasClass('in_progress')) {
        new_obj.removeClass('in_progress').addClass('stalled');
        this.update_member_tasks(source);
        source.parent().droppable('enable');
      }
    },

    update_member_tasks: function(member) {
      member.html("Ain't doin' nothin'!");
    },

    update_pending_tasks: function(pending) {
      if (pending.find('.task').length == 0) {
        pending.html("You did everything?  Yeah right.  Better <a href='"+this.options.tasks_url+"/new'>add another task</a>.");
      }
    },

    update_member: function(member_id, task_id) {
      $.ajax({
        type: 'POST',
        data: {
          'member[task_id]': task_id,
          'authenticity_token': this.options.auth_token,
          '_method': 'put'
        },
        url: this.options.members_url+'/'+member_id+'.xml',
        complete: function() { }
      });
    }
  }
})(jQuery);

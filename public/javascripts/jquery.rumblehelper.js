(function($) {
  $.rumblehelper = {};

  $.rumblehelper.dashboard = {
    options: { },

    clear_fix: $('<div class="clear"></div>'),

    init: function() {
      $.extend(this.options, {
        tasks_url: $('#tasks_url').html(),
        members_url: $('#members_url').html(),
        auth_token: $('#auth_token').html()
      });
      $('.task .timeago').timeago();
      $('.ui-draggable').draggable();
      $('.member').droppable(this.member_droppable_options).each(function() {
        obj = $(this);
        if (obj.find('.task').length == 1) {
          obj.droppable('disable');
        }
      });
      $('#pending_tasks').droppable(this.pending_droppable_options);
      $('#finished_tasks').droppable(this.finished_droppable_options);
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

    finished_droppable_options: {
      accept: '.in_progress, .todo, .stalled',
      drop: function(event, ui) {
        task_id = ui.draggable.attr('id').substring(5);

        member = ui.draggable.parents('.member');
        member_id = null;
        if (member.length == 1) {
          member_id = member.attr('id').substring(7);
        }

        $.rumblehelper.dashboard.move_draggable(ui.draggable, this);

        if (member_id) {
          $.rumblehelper.dashboard.update_member(member_id, '', true);
        }
        else {
          $.rumblehelper.dashboard.update_task(task_id, 'done');
        }
      }
    },

    move_draggable: function(draggable, destination) {
      source = draggable.parent();
      destination = $(destination);

      new_obj = draggable.clone().attr('style', '');
      tasks = destination.find('.tasks')
      if (tasks.find('.task').length == 0) {
        tasks.html(new_obj);
        tasks.append(this.clear_fix);
      }
      else {
        tasks.prepend(new_obj);
      }
      draggable.remove();

      if (destination.attr('id') == "finished_tasks") {
        new_obj.removeClass('ui-draggable');
        new_obj.find('.status').html('Done');
      } else {
        new_obj.draggable();
        if (new_obj.hasClass('todo') || new_obj.hasClass('stalled')) {
          new_obj.removeClass('todo').removeClass('stalled').addClass('in_progress');
          new_obj.find('.status').html('In progress');
          this.update_pending_tasks(source);
        } else if (new_obj.hasClass('in_progress')) {
          new_obj.removeClass('in_progress').addClass('stalled');
          new_obj.find('.status').html('Stalled');
          this.update_member_tasks(source);
          source.parent().droppable('enable');
        }
      }
      new_obj.find('.timeago').attr('title', this.current_iso8601_date).timeago();
    },

    update_member_tasks: function(member) {
      member.html("Ain't doin' nothin'!");
    },

    update_pending_tasks: function(pending) {
      if (pending.find('.task').length == 0) {
        pending.html("You did everything?  Yeah right.  Better <a href='"+this.options.tasks_url+"/new'>add another task</a>.");
      }
    },

    update_member: function(member_id, task_id, finish_task) {
      data = {
        'member[task_id]': task_id,
        'authenticity_token': this.options.auth_token,
        '_method': 'put'
      };
      if (finish_task) {
        data['member[finish_task]'] = true;
      }
      $.ajax({
        type: 'POST', data: data,
        url: this.options.members_url+'/'+member_id+'.xml',
        complete: function() { }
      });
    },

    update_task: function(task_id, status) {
      $.ajax({
        type: 'POST',
        data: {
          'task[status]': status,
          'authenticity_token': this.options.auth_token,
          '_method': 'put'
        },
        url: this.options.tasks_url+'/'+task_id+'.xml',
        complete: function() { }
      });
    },

    current_iso8601_date: function() {
      d = new Date();
      year = d.getUTCFullYear();
      month = d.getUTCMonth() + 1;
      if (month < 10)
        month = '0' + month;
      day = d.getUTCDate();
      if (day < 10)
        day = '0' + day;
      hour = d.getUTCHours();
      if (hour < 10)
        hour = '0' + hour;
      minute = d.getUTCMinutes();
      if (minute < 10)
        minute = '0' + minute;
      second = d.getUTCSeconds();
      if (second < 10)
        second = '0' + second;

      return year+'-'+month+'-'+day+'T'+hour+':'+minute+':'+second+'Z';
    }
  }
})(jQuery);

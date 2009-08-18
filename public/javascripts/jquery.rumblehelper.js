(function($) {
  $.timeago.settings.strings.prefixAgo = 'for';
  $.timeago.settings.strings.suffixAgo = null;

  $.rumblehelper = {};

  $.rumblehelper.dashboard = {
    options: { },

    clear_fix: $('<div class="clear"></div>'),

    init: function(logged_in) {
      $.extend(this.options, {
        tasks_url: $('#tasks_url').html(),
        members_url: $('#members_url').html(),
        auth_token: $('#auth_token').html(),
        logged_in: logged_in
      });

      // this could be DRY'd up a little
      $('.task').rh_setup_tasks();
      if (logged_in) {
        $('.ui-draggable').draggable({revert: true});
        $('.member').droppable(this.member_droppable_options).each(function() {
          obj = $(this);
          if (obj.find('.task').length == 1) {
            obj.droppable('disable');
          }
        });
        $('#pending_tasks').droppable(this.pending_droppable_options);
        $('#finished_tasks').droppable(this.finished_droppable_options);
      }
    },

    member_droppable_options: {
      accept: '.todo, .stalled',
      drop: function(event, ui) {
        task_id = ui.draggable.attr('id').substring(5);
        $.rumblehelper.dashboard.move_draggable(ui, this);

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
        $.rumblehelper.dashboard.move_draggable(ui, this);

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

        $.rumblehelper.dashboard.move_draggable(ui, this);

        if (member_id) {
          $.rumblehelper.dashboard.update_member(member_id, '', true);
        }
        else {
          $.rumblehelper.dashboard.update_task(task_id, 'done');
        }
      }
    },

    move_draggable: function(ui, destination) {
      source = ui.draggable.parents('.tasks_bubble');
      destination = $(destination);

      new_obj = this.clone_task(ui.draggable);
      destination.find('.tasks').prepend(new_obj);
      ui.helper.remove();
      ui.draggable.remove();
      this.toggle_task_boxes(source);
      this.toggle_task_boxes(destination);

      if (destination.attr('id') == "finished_tasks") {
        new_obj.removeClass('ui-draggable');
        new_obj.find('.status').html('Done');
      } else {
        new_obj.draggable({revert: true});
        if (new_obj.hasClass('todo') || new_obj.hasClass('stalled')) {
          new_obj.removeClass('todo').removeClass('stalled').addClass('in_progress');
          new_obj.find('.status').html('In progress');
        } else if (new_obj.hasClass('in_progress')) {
          new_obj.removeClass('in_progress').addClass('stalled');
          new_obj.find('.status').html('Stalled');
          source.droppable('enable');
        }
      }
      new_obj.find('.timeago').attr('title', this.current_iso8601_date).timeago();
    },

    clone_task: function(task) {
      new_obj = task.clone().rh_setup_tasks();
      new_obj.attr('style', '').attr('title', this.current_iso8601_date)
        .find('.icons').hide();
      return new_obj;
    },

    toggle_task_boxes: function(obj) {
      if (obj.find('.task').length == 0) {
        obj.find('.tasks').hide();
        obj.find('.no_tasks').show();
      }
      else {
        obj.find('.tasks').show();
        obj.find('.no_tasks').hide();
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

    edit_task: function() {
      task_id = $(this).parents('.task').attr('id').substring(5);
      window.location = $.rumblehelper.dashboard.options.tasks_url+'/'+task_id+'/edit';
    },

    delete_task: function() {
      confirmation = confirm('Do you really want to delete this task?');
      if (confirmation) {
        dashboard = $.rumblehelper.dashboard;
        task = $(this).parents('.task');
        task_id = task.attr('id').substring(5);
        $.ajax({
          type: 'POST',
          data: {
            'authenticity_token': dashboard.options.auth_token,
            '_method': 'delete'
          },
          url: dashboard.options.tasks_url+'/'+task_id+'.xml',
          complete: function() { }
        });
        task.fadeOut('fast', function() {
          obj = $(this);
          source = obj.parents('.tasks_bubble');
          obj.remove();
          dashboard.toggle_task_boxes(source);
        });
      }
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
  };

  $.fn.rh_setup_tasks = function() {
    dashboard = $.rumblehelper.dashboard;
    this.find('.timeago').timeago();

    if (dashboard.options.logged_in) {
      this.find('.ui-icon-trash').click(dashboard.delete_task);
      this.find('.ui-icon-wrench').click(dashboard.edit_task);
      this.hover(
        function() { $(this).find('.icons').fadeIn(100); },
        function() { $(this).find('.icons').fadeOut(100); }
      );
    }

    this.each(function() {
      description = $(this).find('.description');
      if (description.length > 0) {
        $(this).find('.ui-icon-info').hover(
          function(e) {
            description.fadeIn(100);
          },
          function(e) {
            description.fadeOut(100);
          }
        );
      }
    });
    return this;
  };

})(jQuery);

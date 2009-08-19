(function($) {
  $.timeago.settings.strings.prefixAgo = 'for';
  $.timeago.settings.strings.suffixAgo = null;

  $.rumblehelper = {};

  $.rumblehelper.dashboard = {
    options: { },

    init: function(logged_in) {
      $.extend(this.options, {
        tasks_url: $('#tasks_url').html(),
        members_url: $('#members_url').html(),
        dashboard_url: $('#dashboard_url').html(),
        auth_token: $('#auth_token').html().replace('\r', '').replace('\n', ''),
        logged_in: logged_in
      });

      this.options.timer_id = setInterval(
        this.refresh_dashboard,
        (logged_in ? 10000 : 60000)
      );
      this.setup();
    },

    setup: function() {
      $('.task').rh_setup_tasks();
      if (this.options.logged_in) {
        $('.member').each(function() {
          obj = $(this);
          obj.droppable($.rumblehelper.dashboard.member_droppable_options);
          if (obj.find('.task').length == 1) {
            obj.droppable('disable');
          }
        });
        $('#pending_tasks').droppable(this.pending_droppable_options);
        $('#finished_tasks').droppable(this.finished_droppable_options);
      }
    },

    member_droppable_options: {
      accept: '.done, .todo, .stalled, .in_progress',
      drop: function(event, ui) {
        result = $.rumblehelper.dashboard.move_draggable(ui, this);
        if (result.status == 'noop')
          return;

        member_id = $(this).attr('id').substring(7);
        if (result.source.hasClass('member')) {
          from_member = result.source.attr('id').substring(7);
          $.rumblehelper.dashboard.update_member(member_id, undefined, {from_member: from_member});
        }
        else {
          task_id = result.obj.attr('id').substring(5);
          $.rumblehelper.dashboard.update_member(member_id, task_id);
        }
      }
    },

    pending_droppable_options: {
      accept: '.done, .in_progress',
      drop: function(event, ui) {
        result = $.rumblehelper.dashboard.move_draggable(ui, this);
        task_id = result.obj.attr('id').substring(5);

        if (result.source.hasClass('member')) {
          member_id = source.attr('id').substring(7);
          $.rumblehelper.dashboard.update_member(member_id, '');
        }
        else {
          $.rumblehelper.dashboard.update_task(task_id, 'stalled');
        }
      }
    },

    finished_droppable_options: {
      accept: '.in_progress, .todo, .stalled',
      drop: function(event, ui) {
        result = $.rumblehelper.dashboard.move_draggable(ui, this);
        task_id = result.obj.attr('id').substring(5);

        if (result.source.hasClass('member')) {
          member_id = source.attr('id').substring(7);
          $.rumblehelper.dashboard.update_member(member_id, '', {finish: true});
        }
        else {
          $.rumblehelper.dashboard.update_task(task_id, 'done');
        }
      }
    },

    move_draggable: function(ui, destination) {
      source = ui.draggable.parents('.tasks_bubble');
      destination = $(destination);

      if (source == destination)
        return {status: 'noop'};

      new_obj = this.clone_task(ui.draggable);
      new_obj.find('.timeago').attr('title', this.current_iso8601_date).timeago();

      destination.find('.tasks').prepend(new_obj);
      //ui.helper.remove();
      ui.draggable.hide().removeClass('task');

      if (destination.hasClass('member')) {
        new_obj.removeClass('todo stalled finished').addClass('in_progress')
          .find('.status').html('In progress');
        destination.droppable('disable');
      }
      else if (destination.attr('id') == "pending_tasks") {
        new_obj.removeClass('todo finished in_progress').addClass('stalled')
          .find('.status').html('Stalled');
      }
      else if (destination.attr('id') == "finished_tasks") {
        new_obj.removeClass('todo stalled in_progress').addClass('done')
          .find('.status').html('Done');
      }

      if (source.hasClass('member'))
        source.droppable('enable');

      this.toggle_task_boxes(source);
      this.toggle_task_boxes(destination);

      return {source: source, obj: new_obj, status: 'ok'};
    },

    clone_task: function(task) {
      new_obj = task.clone().rh_setup_tasks()
        .attr('style', '').attr('title', this.current_iso8601_date)
        .removeClass('ui-draggable-dragging');
      new_obj.find('.icons').css('opacity', '1').hide();
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

    update_member: function(member_id, task_id, options) {
      if (!options)
        options = {};

      data = {
        'authenticity_token': this.options.auth_token,
        '_method': 'put'
      };
      if (task_id != undefined)
        data['member[task_id]'] = task_id;

      if (options.finish) {
        data['member[finish_task]'] = true;
      } else if (options.from_member) {
        data['member[move_task_from_member]'] = options.from_member;
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
        task = $(this).parents('.task');
        task_id = task.attr('id').substring(5);
        $.ajax({
          type: 'POST',
          data: {
            'authenticity_token': $.rumblehelper.dashboard.options.auth_token,
            '_method': 'delete'
          },
          url: $.rumblehelper.dashboard.options.tasks_url+'/'+task_id+'.xml',
          complete: function() { }
        });
        task.fadeOut('fast', function() {
          obj = $(this);
          source = obj.parents('.tasks_bubble');
          obj.remove();
          $.rumblehelper.dashboard.toggle_task_boxes(source);
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
    },

    refresh_dashboard: function() {
      if ($('#dashboard').find('.ui-draggable-dragging').length > 0)
        return;

      $('.ui-draggable').draggable('disable');
      $('.task .icons').remove();
      $('#spinner').show();
      $.ajax({
        url: $.rumblehelper.dashboard.options.dashboard_url,
        type: 'GET',
        dataType: 'html',
        success: function(data) {
          $('#dashboard').html(data);
          $.rumblehelper.dashboard.setup();
          $('#spinner').hide();
        }
      });
    }
  };

  $.fn.rh_setup_tasks = function() {
    this.find('.timeago').timeago();

    if ($.rumblehelper.dashboard.options.logged_in) {
      this.draggable({revert: 'invalid'});
      this.find('.ui-icon-trash').click($.rumblehelper.dashboard.delete_task);
      this.find('.ui-icon-wrench').click($.rumblehelper.dashboard.edit_task);
    }
    this.hover(
      function() { $(this).find('.icons').fadeIn(100); },
      function() { $(this).find('.icons').fadeOut(100); }
    );
    this.find('.icons').hover(
      function() { $(this).parent().parent().draggable('disable'); },
      function() { $(this).parent().parent().draggable('enable'); }
    );

    this.each(function() {
      task_id = this.id;
      description = $('#'+task_id+"_description");
      if (description.length > 0) {
        $(this).find('.ui-icon-info').data('description', description.html())
          .hover(
            function(e) {
              $('#description_bubble').html($(this).data('description'))
                .css({top: e.pageY, left: e.pageX + 25}).fadeIn(100);
            },
            function(e) { $('#description_bubble').fadeOut(100); }
          );
      }
    });
    return this;
  };

})(jQuery);

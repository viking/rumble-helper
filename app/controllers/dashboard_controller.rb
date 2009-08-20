class DashboardController < ApplicationController
  def index
    if current_user
      store_location

      @pending_tasks = Task.pending
      @finished_tasks = Task.finished
      @members = Member.all(:order => 'id')
      @num_members = @members.length
      @auth_token = form_authenticity_token

      if request.xhr?
        render :partial => 'tasks'
      end
    else
      render :template => 'dashboard/intro'
    end
  end
end

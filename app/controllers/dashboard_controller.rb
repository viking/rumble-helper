class DashboardController < ApplicationController
  def index
    if current_user
      store_location

      @team = Team.find_by_slug(current_user.team_slug)
      @pending_tasks = @team.tasks.pending
      @finished_tasks = @team.tasks.finished
      @members = @team.members.find(:all, :order => 'id')
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

class DashboardController < ApplicationController
  def index
    if Team.count == 0
      redirect_to new_team_url
    elsif User.count == 0
      redirect_to new_account_url
    else
      store_location

      @pending_tasks = Task.pending
      @finished_tasks = Task.finished
      @members = Member.all
      @num_members = @members.length
      @auth_token = form_authenticity_token

      if request.xhr?
        render :partial => 'tasks'
      end
    end
  end
end

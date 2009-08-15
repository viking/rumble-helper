class DashboardController < ApplicationController
  def index
    if User.count == 0
      redirect_to new_account_url
    elsif Team.count == 0
      redirect_to new_team_url
    else
      @pending_tasks = Task.pending
      @finished_tasks = Task.finished
      @users = User.all
      @num_users = @users.count
    end
  end
end

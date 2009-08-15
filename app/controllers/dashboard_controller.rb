class DashboardController < ApplicationController
  def index
    if User.count == 0
      redirect_to :controller => :users, :action => :new
    else
      @pending_tasks = Task.pending
      @finished_tasks = Task.finished
      @users = User.all
      @num_users = @users.count
    end
  end
end

class TasksController < ApplicationController
  before_filter :require_user
  before_filter :require_team

  # GET /tasks
  # GET /tasks.xml
  def index
    @tasks = @team.tasks.all

    respond_to do |format|
      format.html do
        clear_location
        render :action => 'index'
      end
      format.xml  { render :xml => @tasks }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.xml
  def show
    respond_to do |format|
      format.html do
        redirect_to tasks_url
      end
      format.xml do
        task = @team.tasks.find(params[:id])
        render :xml => task
      end
    end
  end

  # GET /tasks/new
  # GET /tasks/new.xml
  def new
    @task = @team.tasks.build

    respond_to do |format|
      format.html { render :template => 'tasks/form' }
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = @team.tasks.find_by_id(params[:id])
    return head :not_found    unless @task

    render :template => 'tasks/form'
  end

  # POST /tasks
  # POST /tasks.xml
  def create
    @task = @team.tasks.build(params[:task])

    respond_to do |format|
      if @task.save
        flash[:notice] = 'Task was successfully created.'
        format.html do
          if params[:commit] == "Save and continue"
            redirect_to new_task_url
          else
            redirect_back_or_default tasks_url
          end
        end
        format.xml  { render :xml => @task, :status => :created, :location => @task }
      else
        format.html { render :action => "form" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.xml
  def update
    @task = @team.tasks.find_by_id(params[:id])
    return head(:not_found) unless @task

    respond_to do |format|
      if @task.update_attributes(params[:task])
        format.html do
          flash[:notice] = 'Task was successfully updated.'
          redirect_back_or_default tasks_url
        end
        format.xml  { head :ok }
      else
        format.html { render :action => "form" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.xml
  def destroy
    @task = @team.tasks.find_by_id(params[:id])
    return head(:not_found) unless @task

    @task.destroy
    respond_to do |format|
      format.html { redirect_back_or_default tasks_url }
      format.xml  { head :ok }
    end
  end

  private
    def require_team
      @team = Team.find_by_slug(current_user.team_slug)
      if @team.nil?
        redirect_to new_team_url
        return false
      end
    end
end

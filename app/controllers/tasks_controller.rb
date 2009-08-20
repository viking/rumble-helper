class TasksController < ApplicationController
  before_filter :require_user, :except => [ :index, :show ]
  before_filter :require_team

  # GET /tasks
  # GET /tasks.xml
  def index
    @tasks = Task.all

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
        redirect_to team_tasks_url(@team)
      end
      format.xml do
        task = Task.find(params[:id])
        render :xml => task
      end
    end
  end

  # GET /tasks/new
  # GET /tasks/new.xml
  def new
    @task = Task.new

    respond_to do |format|
      format.html { render :template => 'tasks/form' }
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
    render :template => 'tasks/form'
  end

  # POST /tasks
  # POST /tasks.xml
  def create
    @task = Task.new(params[:task])

    respond_to do |format|
      if @task.save
        flash[:notice] = 'Task was successfully created.'
        format.html do
          if params[:commit] == "Save and continue"
            redirect_to new_team_task_url(@team)
          else
            redirect_back_or_default team_tasks_url(@team)
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
    @task = Task.find_by_id(params[:id])

    return head(:not_found) if @task.nil?
    respond_to do |format|
      if @task.update_attributes(params[:task])
        format.html do
          flash[:notice] = 'Task was successfully updated.'
          redirect_back_or_default team_tasks_url(@team)
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
    @task = Task.find_by_id(params[:id])
    return head(:not_found) if @task.nil?

    @task.destroy
    respond_to do |format|
      format.html { redirect_back_or_default team_tasks_url(@team) }
      format.xml  { head :ok }
    end
  end

  private
    def require_team
      valid = true
      begin
        @team = Team.find(params[:team_id], :conditions => { :public => true })
        if !(action_name == 'index' || action_name == 'show')
          valid = (@team.slug == current_user.team_slug)
        end
      rescue ActiveRecord::RecordNotFound
        valid = false
      end

      if !valid
        render :nothing => true, :status => 404
        return false
      end
    end
end

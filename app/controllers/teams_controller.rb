class TeamsController < ApplicationController
  before_filter :require_user, :except => [ :index, :show ]
  before_filter :requires_no_team, :only => [ :new, :create ]

  # GET /teams
  # GET /teams.xml
  #def index
  #end

  # GET /teams/1
  # GET /teams/1.xml
  def show
    begin
      conditions = ["public = ?", true]
      if current_user
        conditions[0] << "OR slug = ?"
        conditions << current_user.team_slug
      end
      @team = Team.find(params[:id], {
        :include => :members,
        :conditions => conditions
      })
    rescue ActiveRecord::RecordNotFound
      render :nothing => true, :status => 404
      return
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @team }
    end
  end

  # GET /teams/new
  # GET /teams/new.xml
  def new
    @team = Team.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @team }
    end
  end

  ## GET /teams/1/edit
  #def edit
    #@team = Team.find(params[:id])
  #end

  # POST /teams
  # POST /teams.xml
  def create
    @team = Team.new(params[:team].merge({ :slug => current_user.team_slug }))

    respond_to do |format|
      if @team.save
        flash[:notice] = 'Team was successfully created.'
        current_user.assign_to_member!
        format.html { redirect_to(tasks_url) }
        format.xml  { render :xml => @team, :status => :created, :location => @team }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @team.errors, :status => :unprocessable_entity }
      end
    end
  end

  ## PUT /teams/1
  ## PUT /teams/1.xml
  #def update
    #@team = Team.first

    #respond_to do |format|
      #if @team.update_attributes(params[:team])
        #flash[:notice] = 'Team was successfully updated.'
        #format.html { redirect_to(team_url) }
        #format.xml  { head :ok }
      #else
        #format.html { render :action => "edit" }
        #format.xml  { render :xml => @team.errors, :status => :unprocessable_entity }
      #end
    #end
  #end

  private
    def requires_no_team
      if (team = Team.find_by_slug(current_user.team_slug))
        redirect_to team_url(team)
        return false
      end
    end
end

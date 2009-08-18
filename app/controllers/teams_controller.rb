class TeamsController < ApplicationController
  before_filter :require_user, :only => [ :edit, :update ]

  # GET /teams/1
  # GET /teams/1.xml
  def show
    @team = Team.first
    if @team.nil?
      redirect_to :action => 'new'
      return
    end
    @members = Member.all

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @team }
    end
  end

  # GET /teams/new
  # GET /teams/new.xml
  def new
    if Team.count > 0
      redirect_to :action => 'show'
      return
    end

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
    if Team.count > 0
      redirect_to :action => 'show'
      return
    end

    @team = Team.new(params[:team])

    respond_to do |format|
      if @team.save
        flash[:notice] = 'Team was successfully created.'
        format.html { redirect_to(new_account_url) }
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
end

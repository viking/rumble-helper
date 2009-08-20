class MembersController < ApplicationController
  before_filter :require_user
  before_filter :require_team

  # GET /members
  # GET /members.xml
  def index
    respond_to do |format|
      format.html { redirect_to root_url }
      format.xml  { render :xml => @team.members }
    end
  end

  # GET /members/1
  # GET /members/1.xml
  def show
    respond_to do |format|
      format.html do
        redirect_to root_url
      end
      format.xml do
        render :xml => @team.members.find(params[:id])
      end
    end
  end

  # PUT /members/1
  # PUT /members/1.xml
  def update
    @member = @team.members.find(params[:id])

    respond_to do |format|
      if @member.update_attributes(params[:member])
        format.html do
          flash[:notice] = 'Member was successfully updated.'
          redirect_to(root_url)
        end
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @member.errors, :status => :unprocessable_entity }
      end
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

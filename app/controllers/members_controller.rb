class MembersController < ApplicationController
  before_filter :require_user, :only => [ :update ]

  # GET /members
  # GET /members.xml
  def index
    respond_to do |format|
      format.html do
        redirect_to root_url
      end
      format.xml do
        render :xml => Member.all
      end
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
        render :xml => Member.find(params[:id])
      end
    end
  end

  # PUT /members/1
  # PUT /members/1.xml
  def update
    @member = Member.find(params[:id])

    respond_to do |format|
      if @member.update_attributes(params[:member])
        format.html do
          redirect_to(@member)
          flash[:notice] = 'Member was successfully updated.'
        end
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @member.errors, :status => :unprocessable_entity }
      end
    end
  end
end

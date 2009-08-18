class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]

  def new
    @members = Member.unassigned
    if @members.empty?
      redirect_to root_url
    else
      @user = User.new
    end
  end

  def create
    @members = Member.unassigned
    if @members.empty?
      redirect_to root_url
      return
    end
    @user = User.new(params[:user])

    @user.save do |result|
      if result
        flash[:notice] = "Account registered!"
        if Task.count == 0
          redirect_to tasks_url
        else
          redirect_back_or_default root_url
        end
      else
        render :action => :new
      end
    end
  end

  def show
    @user = @current_user
  end

  def edit
    @user = @current_user
  end

  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end
end

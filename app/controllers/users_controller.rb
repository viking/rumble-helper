class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]

  def new
    @members = Member.unassigned
    if @members.empty?
      redirect_to root_url
    else
      @num_users = User.count
      @user = User.new
    end
  end

  def create
    @members = Member.unassigned.all
    if @members.empty?
      redirect_to root_url
      return
    end
    @user = User.new(params[:user])

    @user.save do |result|
      if result
        flash[:notice] = "Account registered!"
        if User.count == 1
          if Member.unassigned.count == 0
            # this is all there is!
            flash[:long_notice] = <<-EOF
              Great!  Signup successful!  Next, add a task or fifty that you
              want to accomplish.
            EOF
            redirect_to new_task_url
          else
            flash[:long_notice] = <<-EOF
              Great!  Signup successful!  You can give these codes to your other team
              members so that they can sign up.  Next, <a href="#{new_task_url}">add some tasks</a>
              that you want your team to accomplish.
            EOF
            redirect_to members_url
          end
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
    @user = @current_user
    if params[:user][:email].blank?
      params[:user].delete(:email)
    end
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end
end

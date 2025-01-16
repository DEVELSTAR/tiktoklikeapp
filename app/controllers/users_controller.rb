class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:edit, :update, :destroy, :show, :deactivate, :activate, :destroy, :follow, :unfollow]

  def manage_users
    @users = User.order(created_at: :desc)
  end

  def index
    case params[:filter]
    when 'my_followers'
      @users = current_user.followers.order(created_at: :desc).map(&:follower)
    when 'my_following'
      @users = current_user.following.order(created_at: :desc).map(&:followed)
    else
      @users = User.where.not(id: current_user.id).order(created_at: :desc)
    end
  end

  def show
  end

  def new
    @user = User.new
  end

  def add_user
    @user = User.new(user_params)
    if @user.save
      redirect_to manage_users_users_path, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    if @user.update(user_params)
      redirect_to manage_users_users_path, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def activate
    if @user.update(active: true)
      redirect_to manage_users_users_path, notice: "#{@user.name}'s account has been activated."
    else
      redirect_to user_path(@user), alert: "Failed to activate account."
    end
  end

  def deactivate
    if @user == current_user
      if @user.update(active: false)
        sign_out @user
        redirect_to root_path, notice: "Your account has been deactivated. You can reactivate it by logging in again."
      else
        redirect_to user_path(@user), alert: "Failed to deactivate account."
      end
    else
      if @user.update(active: false)
        redirect_to manage_users_users_path, notice: "#{@user.name}'s account has been deactivated."
      else
        redirect_to user_path(@user), alert: "Failed to deactivate account."
      end
    end
  end

  def follow
    current_user.follow(@user)
    redirect_to users_path, notice: "You are now following #{@user.name}."
  end

  def unfollow
    current_user.unfollow(@user)
    redirect_to users_path, notice: "You have unfollowed #{@user.name}."
  end

  def destroy
    if @user == current_user
      if @user.destroy
        redirect_to root_path, notice: "Your account has been permanently deleted."
      else
        redirect_to user_path(@user), alert: "Failed to delete account."
      end
    else
      if @user.destroy
        redirect_to manage_users_users_path, notice: "#{@user.name}'s account has been permanently deleted."
      else
        redirect_to user_path(@user), alert: "Failed to delete account."
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :user_type, :name, :picture).tap do |whitelisted|
      if params[:user][:password].blank?
        whitelisted.delete(:password)
        whitelisted.delete(:password_confirmation)
      end
    end
  end
  
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :user_type, :name, :picture)
  end
end

class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin, only: [:index, :edit, :update, :destroy]
  before_action :set_user, only: [:edit, :update, :destroy, :show]

  def manage_users
    @users = User.order(created_at: :desc)
  end

  def index
    @users = User.order(created_at: :desc)
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
    if @user.update(user_params)
      redirect_to manage_users_users_path, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to manage_users_users_path, notice: 'User was successfully destroyed.'
  end

  private

  def require_admin
    redirect_to root_path unless current_user.admin?
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :user_type, :name, :picture)
  end
end

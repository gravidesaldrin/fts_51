class Admin::UsersController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!

  def index
    @users = @users.order(:name).page params[:page]
  end

  def create
    @user.confirm!
    if @user.save
      flash[:success] = t ".success"
      redirect_to admin_users_path
    else
      render :new
    end
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".success"
      if current_user == @user
        redirect_back_or admin_user_path @user
      else
        redirect_back_or admin_users_path
      end
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation, :role, :avatar, :remove_avatar
  end
end

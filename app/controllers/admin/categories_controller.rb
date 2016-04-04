class Admin::CategoriesController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!

  def index
    @categories = @categories.order(:name).page params[:page]
  end

  def create
    @category = Category.new category_params
    if @category.save
      Notify.new(@category.name).notify_users
      flash[:success] = t ".success"
      redirect_to admin_categories_path
    else
      render :new
    end
  end

  def update
    if @category.update_attributes category_params
      flash[:success] = t ".success"
      redirect_back_or admin_categories_path
    else
      render :edit
    end
  end

  def destroy
    @category.destroy
    flash[:success] = t ".success"
    redirect_to admin_categories_path
  end

  private
  def category_params
    params.require(:category).permit :id, :name, :image, :remove_image
  end
end

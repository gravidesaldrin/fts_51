class CategoriesController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!
  def index
    @categories = @categories.page params[:page]
    @exam = Exam.new
  end
end

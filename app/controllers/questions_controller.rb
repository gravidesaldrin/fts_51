class QuestionsController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!

  def index
    @categories = Category.all
    if params[:category_id]
      @category = Category.find_by id: params[:category_id]
    else
      @category = Category.first
    end
    unless @category.blank?
      @questions = Question.search(@category, params[:filter], current_user)
      @questions = Kaminari.paginate_array(@questions).
        page(params[:page]).per(10)
    end
  end
end

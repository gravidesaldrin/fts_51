class Admin::QuestionsController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!
  before_action :find_all_category, only: [:new, :edit]

  def index
    @questions = @questions.order(:content).page params[:page]
  end

  def new
    @question.options.build
  end

  def create
    @question = Question.new question_params
    if @question.save
      flash[:success] = t ".success"
      redirect_to admin_questions_path
    else
      render :new
    end
  end

  def update
    if @question.update_attributes question_params
      flash[:success] = t ".success"
      redirect_back_or [:admin, @question]
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    flash[:success] = t ".success"
    redirect_to admin_questions_path
  end

  private
  def question_params
    params.require(:question).permit :id, :category_id, :content,
      :question_type, options_attributes: [:id, :content, :correct, :_destroy]
  end
  def find_all_category
    @categories = Category.all
  end
end

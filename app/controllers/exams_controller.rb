class ExamsController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!

  def create
    @exam = Exam.new exam_params
    if @exam.save
      redirect_to edit_exam_path current_user.current_exam
    else
      flash.now[:warning] = t ".warning"
      redirect_to categories_path
    end
  end

  def edit
    @limit = Category::TOTAL_ITEM_PER_EXAM
    @items = @exam.answers
  end

  def update
    if @exam.update_attributes exam_params
      redirect_to answers_path id: @exam.id
    else
      render :edit
    end
  end

  private
  def exam_params
    params.require(:exam).permit :id, :category_id, :user_id, :correct, :total,
      answers_attributes: [:id, :question_id, :option_id, :text_answer]
  end
end

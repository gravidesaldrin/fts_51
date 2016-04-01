class AnswersController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!

  def index
    @exam = Exam.find params[:id]
    @answers = @exam.answers.page params[:page]
  end
end

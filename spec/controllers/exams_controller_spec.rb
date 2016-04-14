require "rails_helper"
require "support/controller_helpers"

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.include ControllerHelpers, type: :controller
end

RSpec.describe ExamsController, type: :controller do
  fixtures :categories
  fixtures :questions
  fixtures :options
  fixtures :users
  before do
    @user1 = users(:user2)
    @category = Category.first
    sign_in @user1
  end
  it {should use_before_action(:authenticate_user!)}
  context "GET #index" do
    it "assign finished exams to @exams" do
      get :index
      expect(assigns(:exams)).to eq(@user1.exams.finished)
    end
    it "should redirect to index" do
      get :index
      expect(response).to render_template("index")
    end
  end
  context "POST #create" do
    before do
      @valid = {category_id: @category.id,
        user_id: @user1.id,
        correct: 0,
        total: 20,
        cancelled_time: nil}
      @invalid = {category_id: nil,
        user_id: nil,
        correct: 0,
        total: 20,
        cancelled_time: nil}
    end
    it "should permit valid fields" do
      should permit(:category_id, :user_id, :correct, :total, :cancelled_time).
        for(:create, params: {exam: @valid}).on(:exam)
    end
    it "should expect the created Exam to @exam" do
      post :create, exam: @valid
      exam = Exam.last
      expect(assigns(:exam)).to eq(exam)
    end
    it "should redirect to index (valid)" do
      post :create, exam: @valid
      expect(response).to redirect_to edit_exam_path(assigns :exam)
    end
    it "should redirect to index (invalid)" do
      post :create, exam: @invalid
      expect(response).to redirect_to categories_path
    end
  end
  context "GET #edit" do
    before do
      @valid = {category_id: @category.id,
        user_id: @user1.id,
        correct: 0,
        total: 20,
        cancelled_time: nil}
    end
    it "should assign total item per exam to @limit" do
      post :create, exam: @valid
      exam = Exam.last
      get :edit, id: exam.id
      expect(assigns(:limit)).to eq(Category::TOTAL_ITEM_PER_EXAM)
    end
    it "should assign answers of exam to @items" do
      post :create, exam: @valid
      exam = Exam.last
      get :edit, id: exam.id
      expect(assigns(:items)).to eq(exam.answers)
    end
  end
  context "PATCH #update" do
    before do
      @valid = {category_id: @category.id,
        user_id: @user1.id,
        correct: 0,
        total: 20,
        cancelled_time: nil}
      post :create, exam: @valid
      @exam = Exam.last
      get :edit, id: @exam.id
      @answers_valid = {id: @exam.id,
        answers_attributes: {
          "0":{
          question_id: 1,
          option_id: 1}}}
      @answers_invalid = {id: @exam.id,
        category_id: nil,
        user_id: nil,
        answers_attributes: {
          "0":{
          question_id: 1,
          option_id: 1}}}
    end
    it "should assign answers to @exam" do
      patch :update, id: @exam.id, exam: @answers_valid
      expect(@exam.answers).not_to be nil
    end
    it "should not update exam if invalid params" do
      before_update = @exam
      patch :update, id: @exam.id, exam: @answers_invalid
      expect(@exam).to eq(before_update)
    end
    it "should redirect to answers_path after updating exam" do
      patch :update, id: @exam.id, exam: @answers_valid
      expect(response).to redirect_to(answers_path id: @exam.id)
    end
    it "should render edit after updating invalid exam" do
      patch :update, id: @exam.id, exam: @answers_invalid
      expect(response).to render_template("edit")
    end
  end
end

require "rails_helper"
require "support/controller_helpers"

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.include ControllerHelpers, type: :controller
end

RSpec.describe Admin::QuestionsController, type: :controller do
  fixtures :users
  fixtures :questions
  fixtures :options
  before do
    @user1 = users(:user1)
    sign_in @user1
  end
  it {should use_before_action(:authenticate_user!)}
  it {should use_before_action(:find_all_category)}
  context "GET #index" do
    it "assign all questions to @questions" do
      questions = Question.order(:content)
      get :index
      expect(assigns(:questions).to_a).to eq(questions.to_a)
    end
    it "should redirect to index" do
      get :index
      expect(response).to render_template("index")
    end
  end
  context "GET #new" do
    it "assign new Question to @questions" do
      question = Question.new
      question.options.build
      get :new
      expect(assigns(:question).to_json).to eq(question.to_json)
    end
    it "should redirect to new" do
      get :new
      expect(response).to render_template("new")
    end
  end
  context "POST #create" do
    before do
      options = {
        "0": {content: "Oktubre",
          correct: true},
        "1": {content: "Oktanch"}}
      @valid = {category_id: 1,
        content: "What is the tagalog of October ?",
        question_type: "single",
        options_attributes: options
        }
      @invalid = {category_id: nil,
        content: "",
        question_type: "single",
        options_attributes: options
        }
      @question_count = Question.all.count
    end
    it "assign increment count of Questions after create" do
      post :create, question: @valid
      expect(Question.all.count).to eq(@question_count + 1)
    end
    it "assign not increment count of Questions after create (invalid)" do
      post :create, question: @invalid
      expect(Question.all.count).not_to eq(@question_count + 1)
    end
    it "should redirect to admin_questions_path after create" do
      post :create, question: @valid
      expect(response).to redirect_to(admin_questions_path)
    end
    it "should render new after create invalid question" do
      post :create, question: @invalid
      expect(response).to render_template("new")
    end
  end
  context "PATCH #update" do
    before do
      options = {
        "0": {content: "Oktubre",
          correct: true},
        "1": {content: "Nobyembre"}}
      valid = {category_id: 1,
        content: "What is the tagalog of October ?",
        question_type: "single",
        options_attributes: options
        }
      @question = Question.create(valid)
    end
    it "should update with valid value" do
      patch :update, id: @question.id, question: {content: "November"}
      expect(assigns(:question).content).to eq("November")
    end
    it "should not update with invalid value" do
      befor_update = @question
      patch :update, id: @question.id, question: {content: ""}
      expect(@question).to eq(befor_update)
    end
    it "should redirect to users_path after updating valid" do
      patch :update, id: @question.id, question: {content: "November"}
      expect(response).to redirect_to [:admin, @question]
    end
    it "should redirect to users_path after updating valid" do
      patch :update, id: @question.id, question: {content: ""}
      expect(response).to render_template("edit")
    end
  end
  context "delete #DESTROY" do
    it "should decrement Question after destroy" do
      question_count = Question.all.count
      delete_question = questions(:question1).id
      delete :destroy, id: delete_question
      expect(Question.all.count).to eq(question_count - 1)
    end
    it "should redirect to admin_questions_path after delete" do
      delete_question = questions(:question1).id
      delete :destroy, id: delete_question
      expect(response).to redirect_to(admin_questions_path)
    end
  end
end

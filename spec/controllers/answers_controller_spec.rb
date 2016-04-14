require "rails_helper"
require 'support/controller_helpers'

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.include ControllerHelpers, type: :controller
end

RSpec.describe AnswersController, type: :controller do
  fixtures :users
  fixtures :categories
  before do
    @user1 = users(:user2)
    sign_in @user1
    @exam = Exam.create(category_id: categories(:category1).id,
      user_id: @user1.id,
      correct: 0,
      total: 20,
      cancelled_time: nil)
    @exam.update_attributes(id: @exam.id,
      answers_attributes: {"0":{
        question_id: 1,
        option_id: 1}})
  end
  it {should use_before_action(:authenticate_user!)}
  context "GET #index" do
    it "assign exam to @exam" do
      get :index, id: @exam.id
      expect(assigns(:exam)).to eq(@exam)
    end
    it "assign answers for @exam to @answers" do
      get :index, id: @exam.id
      expect(assigns(:answers)).to eq(@exam.answers)
    end
    it "should redirect to index" do
      get :index, id: @exam.id
      expect(response).to render_template("index")
    end
  end
end

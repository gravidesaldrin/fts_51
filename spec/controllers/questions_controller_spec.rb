require "rails_helper"
require "support/controller_helpers"

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.include ControllerHelpers, type: :controller
end

RSpec.describe QuestionsController, type: :controller do
  fixtures :categories
  fixtures :questions
  fixtures :options
  fixtures :users
  before do
    @categories = Category.all
    @user1 = users(:user1)
    sign_in @user1
  end
  context "GET #index" do
    before do
      @category = @categories.first
    end
    it {should use_before_action(:authenticate_user!)}
    it "assign all category to @categories" do
      get :index
      expect(assigns(:categories)).to eq(@categories)
    end
    it "assign category by id to @category (without params)" do
      get :index
      expect(assigns(:category)).to eq(@categories.first)
    end
    it "assign category by id to @category (with params)" do
      get :index, category_id: @category.id
      expect(assigns(:category)).to eq(@category)
    end
    it "should search all questions of current_user" do
      question = Question.search(@category, "all", @user1)
      get :index, category_id: @category.id, filter: "all"
      expect(assigns(:questions)).to eq(question)
    end
    it "should search learned questions of current_user" do
      question = Question.search(@category, "learned", @user1)
      get :index, category_id: @category.id, filter: "learned"
      expect(assigns(:questions)).to eq(question)
    end
    it "should search unlearned questions of current_user" do
      question = Question.search(@category, "unlearned", @user1)
      get :index, category_id: @category.id, filter: "unlearned"
      expect(assigns(:questions)).to eq(question)
    end
    it "after destroy redirect curret_user profile" do
      get :index
      expect(response).to render_template("index")
    end
  end
end


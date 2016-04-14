require "rails_helper"
require 'support/controller_helpers'

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.include ControllerHelpers, type: :controller
end

RSpec.describe CategoriesController, type: :controller do
  fixtures :users
  before do
    @user1 = users(:user2)
    sign_in @user1
  end
  it {should use_before_action(:authenticate_user!)}
  context "GET #index" do
    it "assign categories to @categories" do
      categories = Category.all
      get :index
      expect(assigns(:categories).to_a).to eq(categories.to_a)
    end
    it "assign a new Exam to @exam" do
      exam = Exam.new
      get :index
      expect(assigns(:exam).to_json).to eq(exam.to_json)
    end
    it "should redirect to index" do
      get :index
      expect(response).to render_template("index")
    end
  end
end

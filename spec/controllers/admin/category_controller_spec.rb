require "rails_helper"
require "support/controller_helpers"

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.include ControllerHelpers, type: :controller
end

RSpec.describe Admin::CategoriesController, type: :controller do
  fixtures :users
  fixtures :categories
  before do
    @user1 = users(:user1)
    sign_in @user1
  end
  it {should use_before_action(:authenticate_user!)}
  context "GET #index" do
    it "assign all categories to @categories" do
      categories = Category.order(:name)
      get :index
      expect(assigns(:categories).to_a).to eq(categories.to_a)
    end
    it "should redirect to index" do
      get :index
      expect(response).to render_template("index")
    end
  end
  context "POST #create" do
    before do
      @valid = {name: "Computer"}
      @invalid = {name: ""}
      @category_count = Category.all.count
    end
    it "assign increment count of Categories after create" do
      post :create, category: @valid
      expect(Category.all.count).to eq(@category_count + 1)
    end
    it "assign not increment count of Categories after create (invalid)" do
      post :create, category: @invalid
      expect(Category.all.count).not_to eq(@category_count + 1)
    end
    it "should redirect to admin_categories_path after create" do
      post :create, category: @valid
      expect(response).to redirect_to(admin_categories_path)
    end
    it "should render new after create invalid category" do
      post :create, category: @invalid
      expect(response).to render_template("new")
    end
  end
  context "PATCH #update" do
    before do
      @category = Category.create(name: "Computer")
    end
    it "should update with valid value" do
      patch :update, id: @category.id, category: {name: "OS"}
      expect(assigns(:category).name).to eq("OS")
    end
    it "should not update with invalid value" do
      befor_update = @category
      patch :update, id: @category.id, category: {name: ""}
      expect(@category).to eq(befor_update)
    end
    it "should redirect to users_path after updating valid" do
      patch :update, id: @category.id, category: {name: "OS"}
      expect(response).to redirect_to admin_categories_path
    end
    it "should redirect to users_path after updating valid" do
      patch :update, id: @category.id, category: {name: ""}
      expect(response).to render_template("edit")
    end
  end
  context "delete #DESTROY" do
    it "should decrement Category after destroy" do
      category_count = Category.all.count
      delete_category = categories(:category1).id
      delete :destroy, id: delete_category
      expect(Category.all.count).to eq(category_count - 1)
    end
    it "should redirect to admin_categories_path after delete" do
      delete_category = categories(:category1).id
      delete :destroy, id: delete_category
      expect(response).to redirect_to(admin_categories_path)
    end
  end
end

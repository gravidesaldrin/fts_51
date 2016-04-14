require "rails_helper"
require "support/controller_helpers"

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.include ControllerHelpers, type: :controller
end

RSpec.describe UsersController, type: :controller do
  fixtures :users
  before do
    sign_in(users(:user2))
  end
  context "GET #index" do
    before do
      @admin = users(:user1)
      @users = User.normal.all
      get :index
    end
    it {should use_before_action(:authenticate_user!)}
    it "should be successful" do
      expect(response).to be_success
    end
    it "assign all normal users to @users" do
      expect(assigns(:users).to_a).to eq(@users.to_a)
    end
    it "should not include and admin" do
      expect(assigns(:users).include? @admin).not_to be true
    end
    it "renders the index template" do
      expect(response).to render_template("index")
    end
  end
end


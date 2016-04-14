require "rails_helper"
require "support/controller_helpers"

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.include ControllerHelpers, type: :controller
end

RSpec.describe ActivitiesController, type: :controller do
  fixtures :users
  before do
    @user1 = users(:user1)
    @user2 = users(:user2)
    sign_in @user1
  end
  it {should use_before_action(:authenticate_user!)}
  context "GET #index" do
    it "assign params user to @user" do
      get :index, id: @user2.id
      expect(assigns(:user)).to eq(@user2)
    end
    it "assign activities of user to @activities" do
      get :index, id: @user2.id
      expect(assigns(:activities)).to eq(@user2.activities)
    end
    it "should redirect to index" do
      get :index, id: @user2.id
      expect(response).to render_template("index")
    end
  end
end

require "rails_helper"
require 'support/controller_helpers'

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.include ControllerHelpers, type: :controller
end

RSpec.describe RelationshipsController, type: :controller do
  fixtures :users
  before do
    @user1 = users(:user2)
    @user2 = users(:user3)
    @user1_following = @user1.following.count
    @user2_followers = @user2.followers.count
    sign_in @user1
  end
  it {should use_before_action(:find_recent_user)}
  context "GET #index" do
    it "assign current_user to @user" do
      get :index, recent_user: @user1, active: "following"
      expect(assigns(:user)).to eq(@user1)
    end
    it "assign @recent_user to @user.following" do
      get :index, recent_user: @user1, active: "following"
      expect(assigns(:users)).to eq(@user1.following)
    end
    it "assign @recent_user to @user.followers" do
      get :index, recent_user: @user1, active: "followers"
      expect(assigns(:users)).to eq(@user1.followers)
    end
    it "should redirect to index" do
      get :index, recent_user: @user1, active: "following"
      expect(response).to render_template("index")
    end
  end
  context "POST #create" do
    before do
      post :create, recent_user: @user1, followed_id: @user2
    end
    it "assign current_user to @recent_user" do
      expect(assigns(:recent_user)).to eq(@user1)
    end
    it "assign followed_id to @follower" do
      expect(assigns(:follower)).to eq(@user2)
    end
    it "should increment count of following of current_user" do
      expect(@user1.following.count).to be == (@user1_following + 1)
    end
    it "should increment count of followers of followed_user" do
      expect(@user2.followers.count).to be == (@user2_followers + 1)
    end
    it "after create redirect curret_user profile" do
      expect(response).to redirect_to(assigns(:follower))
    end
  end
  context "DELETE #destroy" do
    before do
      @user1.follow @user2
      @rel = @user1.active_relationships.last
      @user1_following = @user1.following.count
      @user2_followers = @user2.followers.count
      delete :destroy, recent_user: @user1, id: @rel.id
    end
    it "assign current_user to @recent_user" do
      expect(assigns(:recent_user)).to eq(@user1)
    end
    it "assign the followed user to @followed" do
      expect(assigns(:followed)).to eq(@rel.followed)
    end
    it "should decrement count of following of current_user" do
      expect(@user1.following.count).to be == (@user1_following - 1)
    end
    it "should decrement count of following of current_user" do
      expect(@user2.followers.count).to be == (@user2_followers - 1)
    end
    it "after destroy redirect curret_user profile" do
      expect(response).to redirect_to(assigns(:followed))
    end
  end
end

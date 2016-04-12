require "rails_helper"

RSpec.describe Relationship, type: :model do
  fixtures :users
  it {should belong_to :follower}
  it {should belong_to :followed}
  it "must create Activity after create" do
    dren = users(:user1)
    cris = users(:user2)
    activity_count = Activity.count
    dren.follow cris
    expect(Activity.count).to eql(activity_count + 1)
  end
  it "must create Activity after destroy" do
    dren = users(:user1)
    cris = users(:user2)
    dren.follow cris
    activity_count = Activity.count
    dren.unfollow cris
    expect(Activity.count).to eql(activity_count + 1)
  end
end

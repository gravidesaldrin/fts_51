class Relationship < ActiveRecord::Base
  belongs_to :follower, class_name: User.name
  belongs_to :followed, class_name: User.name

  before_save :follow_activity
  before_destroy :unfollow_activity

  private
  def follow_activity
    Activity.create user_id: self.follower_id, message:
      "follow(s) #{self.followed.name}", action: "follow"
  end

  def unfollow_activity
    Activity.create user_id: self.follower_id, message:
      "unfollow(s) #{self.followed.name}", action: "unfollow"
  end
end

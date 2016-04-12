require "rails_helper"
require "cancan/matchers"

RSpec.describe Ability, type: :model do
  fixtures :users
  it "can manage all category for Admin" do
    user = users(:user1)
    ability = Ability.new(user)
    expect(ability).to be_able_to(:manage, :all)
  end
  it "cannot destroy self.user" do
    user1 = users(:user1)
    ability = Ability.new(user1)
    expect(ability).not_to be_able_to(:destroy, User.find(user1.id))
  end
  it "can read User module by Normal User" do
    user2 = users(:user2)
    ability = Ability.new(user2)
    expect(ability).to be_able_to(:read, User.new)
  end
  it "can edit User module by Normal User" do
    user2 = users(:user2)
    ability = Ability.new(user2)
    expect(ability).to be_able_to(:edit, User.find(user2.id))
  end
  it "cannot edit other User by Normal User" do
    user2 = users(:user2)
    user3 = users(:user3)
    ability = Ability.new(user2)
    expect(ability).not_to be_able_to(:edit, User.find(user3.id))
  end
  it "cannot read Category by Normal User" do
    user2 = users(:user2)
    ability = Ability.new(user2)
    expect(ability).to be_able_to(:read, Category.new)
  end
  it "can manage Exam by Normal User" do
    user2 = users(:user2)
    ability = Ability.new(user2)
    expect(ability).to be_able_to(:manage, Exam.new)
  end
  it "cannot delete Exam by Normal User" do
    user2 = users(:user2)
    ability = Ability.new(user2)
    expect(ability).not_to be_able_to(:destroy, Exam.new)
  end
  it "can read Answer by Normal User" do
    user2 = users(:user2)
    ability = Ability.new(user2)
    expect(ability).to be_able_to(:read, Answer.new)
  end
  it "can read Question by Normal User" do
    user2 = users(:user2)
    ability = Ability.new(user2)
    expect(ability).to be_able_to(:read, Question.new)
  end
end

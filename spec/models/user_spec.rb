require "rails_helper"

RSpec.describe User, type: :model do
  fixtures :users
  fixtures :categories
  fixtures :questions
  it {should have_many :exams}
  it {should have_many :activities}
  it {should have_many :active_relationships}
  it {should have_many :passive_relationships}
  it {should have_many :following}
  it {should have_many :followers}
  it {should validate_presence_of :name}
  it {should validate_presence_of :email}
  it {should validate_length_of(:name).is_at_most(50)}
  it {should validate_length_of(:email).is_at_most(255)}
  it {should validate_uniqueness_of(:email).case_insensitive}
  it {should validate_length_of(:password).is_at_most(72)}
  it "should accept valid email" do
    valid_user = users(:user1)
    expect(valid_user.email).to match(User::VALID_EMAIL_REGEX)
  end
  it "should not accept invalid email" do
    invalid_user = users(:xuser1)
    expect(invalid_user.email).not_to match(User::VALID_EMAIL_REGEX)
  end
  it "should not include Admin in Normal Scope" do
    normal_users = User.normal.find_by role: "Admin"
    expect(normal_users).to be_nil
  end
  it "should include Normal Users in Normal Scope" do
    normal_users = User.normal.find_by role: "Normal"
    expect(normal_users).not_to be_nil
  end
  it "should user1 be Admin" do
    admin = users(:user1)
    expect(admin.admin?).to be true
  end
  it "should user2 not be Admin" do
    normal = users(:user2)
    expect(normal.admin?).not_to be true
  end
  it "should have current_exam after starting an exam" do
    user1 = users(:user1)
    Exam.create(user_id: user1.id, category_id: 1)
    expect(user1.current_exam).not_to be_nil
  end
  it "should not have a current_exam after finishing an exam" do
    user1 = users(:user1)
    Exam.create(user_id: user1.id, category_id: 1, correct: 0) # create
    current_exam = user1.current_exam
    current_exam.update_attributes(finished_time: Time.now) # answering exam
    current_exam.send(:finish_exam)
    expect(user1.current_exam).to be_nil
  end
  it "should include in following after follow" do
    user1 = users(:user1)
    user2 = users(:user2)
    following = user1.following.count
    user1.follow user2
    expect(user1.following.count).to be_equal(following + 1)
  end
  it "should not include in following after unfollow" do
    user1 = users(:user1)
    user2 = users(:user2)
    user1.follow user2
    following = user1.following.count
    user1.unfollow user2
    expect(user1.following.count).to be_equal(following - 1)
  end
  it "should be following after follow" do
    user1 = users(:user1)
    user2 = users(:user2)
    user1.follow user2
    expect(user1.following? user2).to be true
  end
  it "should not be following after unfollow" do
    user1 = users(:user1)
    user2 = users(:user2)
    user1.follow user2
    user1.unfollow user2
    expect(user1.following? user2).not_to be true
  end
  it "should include wrong answers in unlearned_question" do
    user1 = users(:user1)
    category1 = categories(:category1)
    Exam.create(user_id: user1.id, category_id: category1.id, correct: 0)
    current_exam = user1.current_exam
    unanswer = current_exam.answers.first
    wrong_option = Option.find_by question_id: unanswer.question.id,
      correct: false
    unanswer.update_attributes option_id: wrong_option.id
    current_exam.save
    expect(user1.unlearned_question(category1).include? unanswer.question).to be true
  end
  it "should not include correct answers in unlearned_question" do
    user1 = users(:user1)
    category1 = categories(:category1)
    Exam.create(user_id: user1.id, category_id: category1.id, correct: 0)
    current_exam = user1.current_exam
    unanswer = current_exam.answers.first
    wrong_option = Option.find_by question_id: unanswer.question.id,
      correct: true
    unanswer.update_attributes option_id: wrong_option.id
    current_exam.save
    expect(user1.unlearned_question(category1).include? unanswer.question).to be false
  end
  it "statistic should have finished exams" do
    user1 = users(:user1)
    category1 = categories(:category1)
    Exam.create(user_id: user1.id, category_id: category1.id, correct: 0)
    exam1 = user1.current_exam
    exam1.save
    expect(user1.statistic.include? exam1).to be true
  end
  it "statistic should not have cancelled exams" do
    user1 = users(:user1)
    category1 = categories(:category1)
    Exam.create(user_id: user1.id, category_id: category1.id, correct: 0)
    exam1 = user1.current_exam
    exam1.save
    Exam.create(user_id: user1.id, category_id: category1.id, correct: 0)
    exam2 = user1.current_exam
    exam2.update_column :cancelled_time, Time.now
    expect(user1.statistic.include? exam2).to be false
  end
  it "statistic should only for one month only" do
    user1 = users(:user1)
    category1 = categories(:category1)
    Exam.create(user_id: user1.id, category_id: category1.id, correct: 0)
    exam1 = user1.current_exam
    exam1.save
    Exam.create(user_id: user1.id, category_id: category1.id, correct: 0)
    exam2 = user1.current_exam
    exam2.update_column :finished_time, Time.now + 1.month
    expect(user1.statistic.include? exam2).to be false
  end
  it "should downcase all emails" do
    user1 = users(:user1)
    cap_email = user1.email
    user1.update_attributes email: cap_email.upcase
    expect(user1.email).to be == cap_email
  end
end

require "rails_helper"

RSpec.describe Exam, type: :model do
  fixtures :users
  fixtures :categories
  fixtures :questions
  it {should belong_to :user}
  it {should belong_to :category}
  it {should have_many :answers}
  it {should accept_nested_attributes_for(:answers)}
  it "should have answers after create" do
    user1 = users(:user1)
    Exam.create(user_id: user1.id, category_id: 1, correct: 0)
    unanswered_questions = user1.current_exam.answers.select{
      |attribute| attribute.option.nil? or attribute.text_answer.nil?}
    expect(user1.current_exam.answers.count).to be == unanswered_questions.count
  end
  it "should not current_exam after finish exam" do
    user1 = users(:user1)
    Exam.create(user_id: user1.id, category_id: 1, correct: 0)
    user1.current_exam.save
    expect(user1.current_exam).to be_nil
  end
  it "should save activity after finishing a exam" do
    user1 = users(:user1)
    activity = user1.activities.count
    Exam.create(user_id: user1.id, category_id: 1, correct: 0)
    user1.current_exam.save
    expect(user1.activities.count).to be == (activity + 1)
  end
  it "should output final_result" do
    user1 = users(:user1)
    activity = user1.activities.count
    last_exam = Exam.create(user_id: user1.id, category_id: 1, correct: 0)
    last_exam.save
    expect(last_exam.final_result).to be == ("0/20")
  end
  it "should output valid final_result (with one correct answer)" do
    user1 = users(:user1)
    category1 = categories(:category1)
    Exam.create(user_id: user1.id, category_id: category1.id, correct: 0)
    last_exam = user1.current_exam
    unanswer = last_exam.answers.first
    wrong_option = Option.find_by question_id: unanswer.question.id,
      correct: true
    unanswer.update_attributes option_id: wrong_option.id
    last_exam.save
    expect(last_exam.final_result).to be == ("1/20")
  end
end

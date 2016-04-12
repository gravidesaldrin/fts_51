require "rails_helper"

RSpec.describe Question, type: :model do
  fixtures :users
  fixtures :categories
  fixtures :questions
  fixtures :options
  it {should belong_to :category}
  it {should have_many :answers}
  it {should have_many :options}
  it "should include correct answers" do
    user1 = users(:user1)
    category1 = categories(:category1)
    Exam.create(user_id: user1.id, category_id: category1.id, correct: 0)
    current_exam = user1.current_exam
    answered = current_exam.answers.first
    wrong_option = Option.find_by question_id: answered.question.id,
      correct: true
    answered.update_attributes option_id: wrong_option.id
    current_exam.save
    expect(Question.correct(user1).include? answered.question).to be true
  end
  it "should include correct text answers" do
    user1 = users(:user1)
    category1 = categories(:category2)
    Exam.create(user_id: user1.id, category_id: category1.id, correct: 0)
    current_exam = user1.current_exam
    answered = current_exam.answers.first
    answered.update_attributes text_answer: "Table"
    current_exam.save
    expect(Question.correct_text(user1).include? answered.question).to be true
  end
  it {should accept_nested_attributes_for(:options)}
  it "question1 should not be text" do
    single_question = questions(:question1)
    expect(single_question.text?).to be false
  end
  it "question4 should be text" do
    text_question = questions(:question4)
    expect(text_question.text?).to be true
  end
  it "should output correct content (single)" do
    single_question = questions(:question1)
    expect(single_question.correct_content).to be == "Mansanas"
  end
  it "should output correct content (multiple)" do
    multiple_question = questions(:question3)
    expect(multiple_question.correct_content).to be == "Saging, Pakwan"
  end
  it "should output correct content (text)" do
    text_question = questions(:question4)
    expect(text_question.correct_content).to be == "Table"
  end
  it "should include correct answers when search learned" do
    user1 = users(:user1)
    category1 = categories(:category1)
    Exam.create(user_id: user1.id, category_id: category1.id, correct: 0)
    current_exam = user1.current_exam
    correct = current_exam.answers.first
    wrong_option = Option.find_by question_id: correct.question.id,
      correct: true
    correct.update_attributes option_id: wrong_option.id
    current_exam.save
    expect(Question.search(category1, "learned", user1).
      include? correct.question).to be true
  end
  it "should not include correct answers when search unlearned" do
    user1 = users(:user1)
    category1 = categories(:category1)
    Exam.create(user_id: user1.id, category_id: category1.id, correct: 0)
    current_exam = user1.current_exam
    correct = current_exam.answers.first
    wrong_option = Option.find_by question_id: correct.question.id,
      correct: true
    correct.update_attributes option_id: wrong_option.id
    current_exam.save
    expect(Question.search(category1, "unlearned", user1).
      include? correct.question).to be false
  end
  it "should include correct answers when search all" do
    user1 = users(:user1)
    category1 = categories(:category1)
    Exam.create(user_id: user1.id, category_id: category1.id, correct: 0)
    current_exam = user1.current_exam
    correct = current_exam.answers.first
    wrong_option = Option.find_by question_id: correct.question.id,
      correct: true
    correct.update_attributes option_id: wrong_option.id
    current_exam.save
    expect(Question.search(category1, "all", user1).
      include? correct.question).to be true
  end
  it "should not save invalid options (single)" do
    category1 = categories(:category1)
    option_count = Option.count
    option = Question.new(category_id: category1.id, content: "What is radio?",
      question_type: "single", options_attributes: {
      "0":{content:"AM", correct:"1"}, "1":{content:"PM", correct:"1"},
      "2":{content:"FM", correct:"0"}})
    option.save
    expect(Option.count).not_to be > (option_count)
  end
  it "should not save valid options (single)" do
    category1 = categories(:category1)
    option_count = Option.count
    option = Question.new(category_id: category1.id, content: "What is radio?",
      question_type: "single", options_attributes: {
      "0":{content:"AM", correct:"1"}, "1":{content:"PM", correct:"0"},
      "2":{content:"FM", correct:"0"}})
    option.save
    expect(Option.count).to be > (option_count)
  end
  it "should not save invalid options (multiple)" do
    category1 = categories(:category1)
    option_count = Option.count
    option = Question.new(category_id: category1.id, content: "What is radio?",
      question_type: "multiple", options_attributes: {
      "0":{content:"AM", correct:"1"}, "1":{content:"PM", correct:"1"},
      "2":{content:"FM", correct:"1"}})
    option.save
    expect(Option.count).not_to be > (option_count)
  end
  it "should not save valid options (multiple)" do
    category1 = categories(:category1)
    option_count = Option.count
    option = Question.new(category_id: category1.id, content: "What is radio?",
      question_type: "multiple", options_attributes: {
      "0":{content:"AM", correct:"1"}, "1":{content:"PM", correct:"1"},
      "2":{content:"FM", correct:"0"}})
    option.save
    expect(Option.count).to be > (option_count)
  end
  it "should not save invalid options (text)" do
    category1 = categories(:category1)
    option_count = Option.count
    option = Question.new(category_id: category1.id, content: "What is radio?",
      question_type: "text", options_attributes: {
      "0":{content:"AM", correct:"1"}, "1":{content:"PM", correct:"0"}})
    option.save
    expect(Option.count).not_to be > (option_count)
  end
  it "should not save valid options (text)" do
    category1 = categories(:category1)
    option_count = Option.count
    option = Question.new(category_id: category1.id, content: "What is radio?",
      question_type: "text", options_attributes: {
      "0":{content:"AM", correct:"1"}})
    option.save
    expect(Option.count).to be > (option_count)
  end
  it "should not save other question type" do
    category1 = categories(:category1)
    option_count = Option.count
    option = Question.new(category_id: category1.id, content: "What is radio?",
      question_type: "match", options_attributes: {
      "0":{content:"AM", correct:"1"}, "1":{content:"PM", correct:"0"}})
    option.save
    expect(Option.count).not_to be > (option_count)
  end
end

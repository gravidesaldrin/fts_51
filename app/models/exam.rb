class Exam < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  has_many :answers

  after_create :create_items
  before_update :finish_exam
  scope :finished , -> {where "finished_time IS NOT NULL"}

  accepts_nested_attributes_for :answers, allow_destroy: true

  def final_result
    "#{self.correct}/#{self.total}"
  end

  private
  def create_items
    items = self.user.unlearned_question self.category
    limit = Category::TOTAL_ITEM_PER_EXAM
    correct = self.category.questions.correct self.user
    while items.count < limit  do
      added = self.category.questions.sample(limit - items.count)
      items += added
    end
    items = items.sample limit
    items.each do |s|
      Answer.create question_id: s.id, exam_id: self.id
    end
  end
  def finish_exam
    self.correct += self.answers.reject{|attribute| attribute.option.nil?}.
      select{|attribute| attribute.question.question_type != "text" &&
      attribute.option.correct?}.count
    self.correct += self.answers.select{|attribute|
      attribute.question.text? && attribute.question.options.select{|att|
      att.content == attribute.text_answer}.any?}.count
    self.total = self.answers.size
    self.finished_time = Time.now
  end
end

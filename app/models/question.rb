class Question < ActiveRecord::Base
  QUESTION_TYPE = %w[single multiple text]
  paginates_per 10

  belongs_to :category
  has_many :answers
  has_many :options

  scope :correct, -> (user) {joins(answers: [:exam,:option]).
   where("questions.question_type != ? and exams.user_id = ? and
   options.correct = ?", "text", user, true)}

  scope :correct_text, -> (user) {joins(:options, answers: [:exam]).
   where("questions.question_type = ? and exams.user_id = ? and
   answers.text_answer = options.content and options.correct = ?",
   "text", user, true)}

  accepts_nested_attributes_for :options, allow_destroy: true

  validate :number_of_options
  validates_associated :options
  validates :content, presence: true
  validates :question_type, presence: true
  validates :category_id, presence: true

  def text?
    self.question_type == "text"
  end

  def correct_content
    self.options.select{|attribute| attribute.correct}
      .map{|attribute| attribute.content}.join(", ")
  end

  class << self
    def search category, current_filter, current_user
      case current_filter
      when "learned"
        category.questions.correct(current_user) + category.questions.correct_text(current_user)
      when "unlearned"
        current_user.unlearned_question category
      else
        category.questions
      end
    end
  end

  private
  def number_of_options
    option = self.options.size
    correct = self.options.select{|attribute| attribute.correct?}.count
    case self.question_type
    when "single"
      errors.add(:question_type, " is invalid.") unless
        option > 1 and correct == 1 and option != correct
    when "multiple"
      errors.add(:question_type, " is invalid.") unless
        option > 1 and correct > 1 and option != correct
    when "text"
      errors.add(:question_type, " is invalid.") unless
        option == 1 and correct == 1 and option == correct
    else
      errors.add(:question_type, "is not correct.")
    end
  end
end

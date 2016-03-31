class Question < ActiveRecord::Base
  QUESTION_TYPE = %w[single multiple text]

  belongs_to :category
  has_many :answers
  has_many :options

  accepts_nested_attributes_for :options, allow_destroy: true

  validate :number_of_options
  validates_associated :options
  validates :content, presence: true
  validates :question_type, presence: true
  validates :category_id, presence: true

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

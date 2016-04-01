class Category < ActiveRecord::Base
  TOTAL_ITEM_PER_EXAM = 20

  has_many :exams
  has_many :questions
  paginates_per 10
  mount_uploader :image, ImageUploader

  validates :name,  presence: true, length: {maximum: 50}
end

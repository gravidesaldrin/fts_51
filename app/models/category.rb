class Category < ActiveRecord::Base
  has_many :exams
  has_many :questions
  paginates_per 10
  mount_uploader :image, ImageUploader

  validates :name,  presence: true, length: {maximum: 50}
end

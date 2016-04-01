class User < ActiveRecord::Base
  ROLE = %i[Normal Admin]
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  paginates_per 10
  has_many :exams
  has_many :active_relationships,  class_name: Relationship.name,
    foreign_key: :follower_id,
    dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
    foreign_key: :followed_id,
    dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  validates :name,  presence: true, length: {maximum: 50}
  validates :email, presence: true, length: {maximum: 255},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates_length_of :password, within: Devise.password_length,
    allow_blank: true
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :confirmable
  mount_uploader :avatar, AvatarUploader

  def admin?
    self.role == "Admin"
  end

  def current_exam
    exams.find_by finished_time: nil
  end

  def unlearned_question current_category
    current_category.questions.reject{|attribute|
    Question.correct(self).include? attribute}
  end
end

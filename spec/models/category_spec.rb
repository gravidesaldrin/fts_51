require "rails_helper"

RSpec.describe Category, type: :model do
  # it "should have paginate_per" do
  #   expect(Category::paginates_per).to be(10)
  # end
  it "should have TOTAL_ITEM_PER_EXAM" do
    expect(Category::TOTAL_ITEM_PER_EXAM).to be(20)
  end
  it {should have_many :exams}
  it {should have_many :questions}
  it {should validate_presence_of :name}
  it {should validate_length_of(:name).
    is_at_most(50)
  }
end

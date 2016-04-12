require "rails_helper"

RSpec.describe Answer, type: :model do
  it {should belong_to :exam}
  it {should belong_to :question}
  it {should belong_to :option}
end

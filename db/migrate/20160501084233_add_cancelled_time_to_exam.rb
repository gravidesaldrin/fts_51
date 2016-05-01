class AddCancelledTimeToExam < ActiveRecord::Migration
  def change
    add_column :exams, :cancelled_time, :datetime
  end
end

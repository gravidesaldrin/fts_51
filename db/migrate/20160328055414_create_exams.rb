class CreateExams < ActiveRecord::Migration
  def change
    create_table :exams do |t|
      t.references :user, index: true, foreign_key: true
      t.references :category, index: true, foreign_key: true
      t.integer :correct
      t.integer :total
      t.datetime :finished_time
      t.timestamps null: false
    end
    add_index :exams, [:user_id, :category_id]
  end
end

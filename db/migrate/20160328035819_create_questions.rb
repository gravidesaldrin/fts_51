class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.references :category, index: true, foreign_key: true
      t.string :content
      t.string :question_type
      t.timestamps null: false
    end
    add_index :questions, :content
    add_index :questions, :question_type
    add_index :questions, [:category_id, :content], unique: true
  end
end

class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.references :exam, index: true, foreign_key: true
      t.references :question, index: true, foreign_key: true
      t.references :option, index: true, foreign_key: true
      t.string :text_answer
      t.timestamps null: false
    end
    add_index :answers, [:exam_id, :question_id]
    add_index :answers, [:exam_id, :option_id]
  end
end

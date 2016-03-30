class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.references :question, index: true, foreign_key: true
      t.string :content
      t.boolean :correct, default: false
      t.timestamps null: false
    end
    add_index :options, [:question_id, :content]
  end
end

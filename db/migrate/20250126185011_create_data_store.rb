class CreateDataStore < ActiveRecord::Migration[8.0]
  def change
    create_table :data_stores do |t|
      t.timestamps
      t.string :source
      t.string :url
      t.text :question
      t.text :answer
      t.text :wrong_answer
      t.boolean :processed, default: false, null: false
    end
  end
end

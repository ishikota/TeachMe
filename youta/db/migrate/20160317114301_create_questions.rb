class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :title
      t.boolean :solved
      t.integer :good
      t.references :users

      t.timestamps null: false
    end
  end
end

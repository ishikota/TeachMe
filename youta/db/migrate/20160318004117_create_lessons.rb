class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.string :title
      t.integer :day_of_week
      t.integer :period

      t.timestamps null: false
    end
  end
end

class AddUniquenessOnTag < ActiveRecord::Migration
  def change
    add_index :tags, [:name, :lesson_id], unique: true
  end
end

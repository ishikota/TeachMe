class AddLessonIdToQuestion < ActiveRecord::Migration
  def change
    add_reference :questions, :lesson, index: true, foreign_key: true
  end
end

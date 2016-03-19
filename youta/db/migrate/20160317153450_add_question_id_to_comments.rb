class AddQuestionIdToComments < ActiveRecord::Migration
  def change
    add_reference(:comments, :question)
  end
end

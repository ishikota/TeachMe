class FixdefaultValueOfSolved < ActiveRecord::Migration
  def change
    change_column(:questions, :solved, :boolean, null: false)
    change_column_default(:questions, :solved, false)
  end
end

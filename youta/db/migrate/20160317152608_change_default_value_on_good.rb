class ChangeDefaultValueOnGood < ActiveRecord::Migration
  def change
    change_column_default(:questions, :good, 0)
  end
end

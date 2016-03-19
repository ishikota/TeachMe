class RemoveGoodFromQuestion < ActiveRecord::Migration
  def change
    remove_columns(:questions, :good)
  end
end

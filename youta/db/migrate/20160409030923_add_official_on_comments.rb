class AddOfficialOnComments < ActiveRecord::Migration
  def change
    add_column :comments, :official, :boolean, default: false, null: false
  end
end

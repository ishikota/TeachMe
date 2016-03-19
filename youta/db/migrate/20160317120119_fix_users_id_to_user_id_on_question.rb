class FixUsersIdToUserIdOnQuestion < ActiveRecord::Migration
  def change
    change_table :questions do |t|
      t.rename :users_id, :user_id
    end
  end
end

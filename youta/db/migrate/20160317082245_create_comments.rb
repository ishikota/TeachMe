class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content
      t.references :user

      t.timestamps null: false
    end
    add_index :comments, [:user_id, :created_at]
  end
end

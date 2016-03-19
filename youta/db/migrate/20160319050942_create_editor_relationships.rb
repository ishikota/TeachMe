class CreateEditorRelationships < ActiveRecord::Migration
  def change
    create_table :editor_relationships do |t|
      t.references :user
      t.references :lesson

      t.timestamps null: false
    end
  end
end

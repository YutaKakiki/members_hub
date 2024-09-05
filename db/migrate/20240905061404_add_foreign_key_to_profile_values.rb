class AddForeignKeyToProfileValues < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :profile_values, :profile_fields, column: :profile_field_id, on_delete: :cascade
  end
end

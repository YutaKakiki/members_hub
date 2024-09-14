class AddForeignKeyToProfileValues < ActiveRecord::Migration[7.1]
  def change
    # 既存の外部キー制約を削除
    remove_foreign_key :profile_values, :profile_fields

    # 新しい外部キー制約を追加（on_delete: :cascade を追加）
    add_foreign_key :profile_values, :profile_fields, column: :profile_field_id, on_delete: :cascade
  end
end

class ChangeColumnNameOfProfileFields < ActiveRecord::Migration[7.1]
  def change
    rename_column :profile_fields,:field,:name
  end
end

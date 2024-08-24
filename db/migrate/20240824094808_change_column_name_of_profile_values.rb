class ChangeColumnNameOfProfileValues < ActiveRecord::Migration[7.1]
  def change
    rename_column :profile_values,:value,:content
  end
end

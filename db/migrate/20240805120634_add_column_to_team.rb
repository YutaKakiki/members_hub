class AddColumnToTeam < ActiveRecord::Migration[7.1]
  def change
    add_column :teams,:uuid,:string
  end
end

class AddIndexToTeams < ActiveRecord::Migration[7.1]
  def change
    add_index :teams, :uuid
    #Ex:- add_index("admin_users", "username")
  end
end

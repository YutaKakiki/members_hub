class AddIndexToToken < ActiveRecord::Migration[7.1]
  def change
    rename_column :team_invitations, :token, :invitation_digest
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
    add_index :team_invitations, :invitation_digest

  end
end

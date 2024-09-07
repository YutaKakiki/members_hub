class ReanameExpairesAtColumnToTeamInvitation < ActiveRecord::Migration[7.1]
  def change
    rename_column :team_invitations, :expaires_at, :expires_at
  end
end

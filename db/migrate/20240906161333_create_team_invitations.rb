class CreateTeamInvitations < ActiveRecord::Migration[7.1]
  def change
    create_table :team_invitations do |t|
      t.references :team, null:false,foreign_key: true
      t.string :token,null:false
      t.datetime :expaires_at,null:false
      t.timestamps
    end
  end
end

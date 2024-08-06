class Admin < ApplicationRecord
  belongs_to :user
  belongs_to :team

  # ユーザーをチームの管理者に設定
  def self.set_as_admin(user, team)
    user.admins.create({ team_id: team.id })
  end
end

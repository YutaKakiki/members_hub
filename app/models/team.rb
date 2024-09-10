class Team < ApplicationRecord
  # TeamとMemberの中間テーブル
  has_many :members, dependent: :destroy
  # Teamは、複数のメンバー（ユーザー）を所有する
  has_many :member_users, through: :members, source: :user # 関連付けモデルの元の名前はUser
  # TeamとAdminの中間テーブル
  has_one :admin, dependent: :destroy
  # Teamは、単一の管理者（ユーザー）を所有する
  has_one :admin_user, through: :admin, source: :user

  has_one :team_invitation, dependent: :destroy

  has_one_attached :logo, dependent: :destroy

  has_secure_password

  validates :name, presence: true

  has_many :profile_fields, dependent: :destroy

  # 認証情報に合致するチームがあれば返す
  def self.authenticate_team(params)
    return unless params[:team]

    uuid = params[:team][:uuid]
    password = params[:team][:password]
    # チームIDで検索s
    if (team = Team.find_by(uuid:))
      team.authenticate(password) ? team : false
    else
      false
    end
  end

  # 3個以上（デフォルトの項目に加えて1個上追加）の項目があるか
  def team_has_profile_values_more_than_three?
    profile_fields.count >= 3
  end

  def self.create_team(params)
    team=self.new(params)
    team.uuid=SecureRandom.uuid
    team.attach_logo(params)
    team
  end

  def attach_logo(params)
    return unless params[:logo]
    self.logo.attach(params[:logo])
  end

  def self.admin_teams(user)
    user.admin_teams.includes(logo_attachment: :blob)
  end

  def self.joined_teams(user)
    user.teams.includes(logo_attachment: :blob)
  end

  def self.this_is_created_team_now?(user,team)
    team.name == user.admin_teams.last.name
  end
end

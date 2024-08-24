class Team < ApplicationRecord
  # TeamとMemberの中間テーブル
  has_many :members, dependent: :destroy
  # Teamは、複数のメンバー（ユーザー）を所有する
  has_many :member_users, through: :members, source: :user # 関連付けモデルの元の名前はUser
  # TeamとAdminの中間テーブル
  has_one :admin, dependent: :destroy
  # Teamは、単一の管理者（ユーザー）を所有する
  has_one :admin_user, through: :admin, source: :user

  has_one_attached :logo,dependent: :destroy

  has_secure_password

  validates :name, presence: true

  has_many :profile_fields,dependent: :destroy

  # 認証情報に合致するチームがあれば返す
  def self.authenticate_team(params)
    if params[:team]
      uuid=params[:team][:uuid]
      password=params[:team][:password]
        if team=Team.find_by(uuid:)
          team.authenticate(password) ? team : false
        else
          return false
        end
    end
  end

  def is_team_has_profile_values_more_than_3
    self.profile_fields.count >= 3
  end

end

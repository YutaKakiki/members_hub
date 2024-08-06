class Team < ApplicationRecord
  # TeamとMemberの中間テーブル
  has_many :members, dependent: :destroy
  # Teamは、複数のメンバー（ユーザー）を所有する
  has_many :member_users, through: :members, source: :user # 関連付けモデルの元の名前はUser
  # TeamとAdminの中間テーブル
  has_one :admin, dependent: :destroy
  # Teamは、単一の管理者（ユーザー）を所有する
  has_one :admin_user, through: :admin, source: :user

  has_one_attached :logo

  has_secure_password

  validates :name, presence: true
end

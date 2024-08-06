class User < ApplicationRecord
  has_many :auth_providers, dependent: :destroy
  # UserとTeamの中間テーブル
  has_many :members, dependent: :destroy
  # Userは、複数のTeamのメンバーになれる
  has_many :teams, through: :members
  # Userは複数のチームの管理者になれる
  has_many :admins, dependent: :destroy
  # Userは、管理しているチームを取得できる
  has_many :admin_teams, through: :admins, source: :team

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: %i[google_oauth2 line]
end

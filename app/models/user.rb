class User < ApplicationRecord
  has_many :auth_providers, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: %i[google_oauth2 line]

  has_many :members
  has_many :teams,through: :members
  has_many :admins
end

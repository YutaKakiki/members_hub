class ProfileField < ApplicationRecord
  belongs_to :team
  has_one :profile_value, dependent: :destroy
  validates :name, presence: true
end

class ProfileField < ApplicationRecord
  belongs_to :team
  has_many :profile_values
end

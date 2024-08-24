class ProfileValue < ApplicationRecord
  belongs_to :profile_field
  belongs_to :member
end

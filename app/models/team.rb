class Team < ApplicationRecord
  has_many :members
  has_many :users,through: :members
  has_one :admin
end

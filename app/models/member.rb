class Member < ApplicationRecord
  belongs_to :user
  belongs_to :team
  has_many :profile_values, dependent: :destroy

  # memberとなっているチームがあれば、trueを返す
  def self.member_of_team?(user,team)
    user.members.any? { |member| member.team == team }
  end

end

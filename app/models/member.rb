class Member < ApplicationRecord
  belongs_to :user
  belongs_to :team
  has_many :profile_values, dependent: :destroy

  # memberとなっているチームがあれば、trueを返す
  def self.member_of_team?(user,team)
    user.members.any? { |member| member.team == team }
  end

  def build_profile_values(pairs_arr)
    pairs_arr.each do |profile_field_id,content|
      self.profile_values.build({profile_field_id:,content:})
    end
  end

  def has_valid_content?
    # 　全てが正常な値（presence）かどうか
    return true if self.profile_values.all?{|profile_value| profile_value.valid?}
  end

  def save_profile_values
    self.profile_values.each(&:save)
  end
end

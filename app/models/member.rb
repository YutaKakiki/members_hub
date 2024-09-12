class Member < ApplicationRecord
  belongs_to :user
  belongs_to :team
  has_many :profile_values, dependent: :destroy

  has_one_attached :image, dependent: :destroy

  def self.join_team(user, team)
    user.members.create(team_id: team.id)
  end

  # memberとなっているチームがあれば、trueを返す
  def self.member_of_team?(user, team)
    user.members.any? { |member| member.team == team }
  end

  def build_profile_values(pairs_arr)
    pairs_arr.each do |profile_field_id, content|
      profile_values.build({ profile_field_id:, content: })
    end
  end

  def save_profile_values
    profile_values.each(&:save)
  end

  # imageは、memberに紐づける
  def save_image(params)
    return unless params[:image]

    image.attach(params[:image])
    save
  end

  # 次なる管理者
  def self.find_successor(params)
    find_by(id: params[:member_id])
  end

  def self.find_last_joined_team(user)
    user.members.last
  end

  def self.user_is_this_member?(user, member)
    member.user_id == user.id
  end
end

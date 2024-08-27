class Member < ApplicationRecord
  belongs_to :user
  belongs_to :team
  has_many :profile_values, dependent: :destroy

  has_one_attached :image, dependent: :destroy

  # memberとなっているチームがあれば、trueを返す
  def self.member_of_team?(user, team)
    user.members.any? { |member| member.team == team }
  end

  def build_profile_values(pairs_arr)
    pairs_arr.each do |profile_field_id, content|
      profile_values.build({ profile_field_id:, content: })
    end
  end

  def has_valid_content?
    # 全てが正常な値（presence）かどうか
    true if profile_values.all?(&:valid?)
  end

  def save_profile_values
    profile_values.each(&:save)
  end

  # imageは、memberに紐づける
  def save_image(params)
    image.attach(params[:image])
    save
  end
end

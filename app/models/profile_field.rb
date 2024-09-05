class ProfileField < ApplicationRecord
  belongs_to :team
  has_one :profile_value, dependent: :destroy
  validates :name, presence: true

  # 自由に追加できる項目数は７つまで（デフォルトを含めれば９つまで）
  def self.limit_profile_fields?(team)
    true if team.profile_fields.count == 9
  end

  def self.unfilled_profile_field(team,member)
    profile_values=member.profile_values.pluck(:profile_field_id)
    profile_fields=team.profile_fields
    profile_fields.reject do |field|
      profile_values.include?(field.id)
    end
  end
end

class ProfileField < ApplicationRecord
  belongs_to :team
  has_one :profile_value, dependent: :destroy
  validates :name, presence: true

  # 自由に追加できる項目数は７つまで（デフォルトを含めれば９つまで）
  def self.limit_profile_fields?(team)
    true if team.profile_fields.count == 9
  end

  def self.unfilled_profile_field(team, member)
    profile_values = member.profile_values.pluck(:profile_field_id)
    profile_fields = team.profile_fields
    profile_fields.reject do |field|
      profile_values.include?(field.id)
    end
  end

  def self.params_blank?(params)
    params[:name].blank?
  end

  def self.create_default_fields(team)
    return false unless team
    return if team.profile_fields.exists?(name: '名前') && team.profile_fields.exists?(name: '生年月日')

    team.profile_fields.create(name: '名前')
    team.profile_fields.create(name: '生年月日')
  end
end

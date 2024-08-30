module Teams::ProfileFieldsHelper
  # 引数の項目がデフォルト（名前、生年月日）以外であれば、trueを返す
  def default_field?(profile_field)
    true if profile_field.name == '名前' || profile_field.name == '生年月日'
  end

  def team_has_profile_values_more_than_three?(team)
    return false unless team

    team.profile_fields.count >= 3
  end

  def profile_field_present?(profile_field)
    true if profile_field.present? && profile_field.id.present?
  end
end

module Teams::ProfilesHelper
  # 引数の項目がデフォルト（名前、生年月日）以外であれば、trueを返す
  def is_not_default_field?(profile_field)
    return true unless profile_field.name=="名前" || profile_field.name=="生年月日"
  end


  def is_team_has_profile_values_more_than_3(team)
    return false unless team
    team.profile_fields.count >= 3
  end

  def is_profile_field_present?(profile_field)
    return true if profile_field.present? && profile_field.id.present?
  end
end

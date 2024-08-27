module Teams::MembersHelper
  def field_name_and_value_content_pairs_arr(team,member)
    profile_values=member.profile_values
    # Memberインスタンスが持つprofile_valuesから抽出
    service=ReturnProfileAttributePairsService.new(team,member:)
    field_name_and_value_content_pairs=service.call
  end
end

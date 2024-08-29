module Teams::MembersHelper
  def field_name_and_value_content_pairs_arr(team, member)
    # Memberインスタンスが持つprofile_valuesから抽出
    service = ReturnProfileAttributePairsService.new(team, member:)
    service.call
  end
end

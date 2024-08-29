# profile_fieldとcontentのペア配列を作る
# ❶ProfileValueを登録するときに、contentとProfileField.idの２つをペアで入れる場合
# 　=>contentはparamsから抽出
# ❷メンバー一覧ページにて、表示するためのProfileField.nameとProfileValue.contentの２つをペアで返す場合
# 　=>contentはMemberのインスタンスが持つprofile_valuesから抽出
class ReturnProfileAttributePairsService
  def initialize(team, params: nil, member: nil)
    @team = team
    @params = params
    @member = member
  end

  def call
    # ❶の場合
    if @params
      # profile_fieldのidの配列を用意
      profile_field_ids = @team.profile_field_ids
      profile_value_contents = make_contents_arr_from_params(profile_field_ids)
      # ex// [[2,"Example Name"],[4,"Example University"]]
      return profile_field_ids.zip(profile_value_contents)
    end

    # ❷の場合
    return unless @member

    # profile_fieldのnameの配列を用意
    profile_field_names = @team.profile_fields.map(&:name)
    profile_value_contents = makes_contents_arr_from_member
    profile_field_names.zip(profile_value_contents)
  end

  private

  def make_contents_arr_from_params(profile_field_ids)
    # paramsからprofile_valueのcontentの配列を用意
    profile_value_contents = []
    profile_field_size = profile_field_ids.size
    profile_field_size.times do |i|
      profile_value_contents.push(@params["content#{i + 1}"])
    end
    profile_value_contents
  end

  def makes_contents_arr_from_member
    # profile_valueからcontentの配列を用意
    profile_values = @member.profile_values
    profile_values.map(&:content)
  end
end

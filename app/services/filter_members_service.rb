class FilterMembersService
  def self.call(params)
    new(params).call
  end

  def initialize(params)
    @params = params
  end

  def call
    scattered_profile_params = @params.select { |key, _| key.match?(/field\d/) || key.match?(/value\d/) }
    grouped_pairs_params = group_by_profile_pairs(scattered_profile_params)
    filter_members(grouped_pairs_params)
  end

  private

  # scatterd_profile_params={field1:1,value1:"",field2:"",value2:""}
  # => {:profile1=>{:field=>nil, :value=>nil},
  #     :profile2=>{:field=>nil, :value=>nil}}
  def group_by_profile_pairs(params)
    params_size = params.to_h.size / 2
    grouped_pairs_params = {}
    # field1,value1,field2,value2というように並んでいるので、サイズ÷２回で、１ペアあるものと認識する
    if params_size < 2
      field = params['field1']
      value = params['value1']
      pairs_params = { profile1: { field:, value: } }
      grouped_pairs_params.merge!(pairs_params)
    else
      params_size.times do |i|
        field = params["field#{i + 1}"]
        value = params["value#{i + 1}"]
        pairs_params = { "profile#{i + 1}": { field:, value: } }
        grouped_pairs_params.merge!(pairs_params)
      end
    end
    grouped_pairs_params
  end

  def filter_members(params)
    # これに、複数のクエリを追加していく
    query = Member

    # paramsの個数（{profile1:{field:"",value:""},profile2,,,,}）分繰り返す
    params.each_with_index do |(_, value), i|
      # paramsから項目（profile_field.id）と内容（profile_value.content）を読み取る
      field = value[:field].to_i
      content = value[:value]

      # 生年月日は「2002/12/24」などの入力を2002-12-24に変更する
      content=change_date_format(field,content)

      # 異なるprofile_field_idの条件でAND検索するため、項目条件の個数分membersとprofile_valuesを内部結合する
      alias_name_of_profile_values = "profile_values#{i + 1}" # 複数回結合する際、テーブルを識別する必要があるため

      # 内容の検索条件に「、」が含まれている時、OR検索を追加する
      if content.include?('、')
        contents = content.split('、').map { |content| "%#{content}%" }
        # 「、」で区切られたcontentの数だけOR条件を追加する
        content_conditions = contents.map do |_content|
          "#{alias_name_of_profile_values}.content LIKE ? "
        end.join(' OR ')
        # 項目名の条件は同じ
        field_condition = "(#{alias_name_of_profile_values}.profile_field_id= ?)"
        # 項目名の条件と内容の条件をANDで結合する
        #   => 項目名がAかつ、内容がBまたはCまたは...なmemberを探すクエリとなる
        field_and_content_conditions = [field_condition, "(#{content_conditions})"]
        final_conditions = field_and_content_conditions.join(' AND ')
        # where句に上で追加した条件を挿入
        # ? のプレースホルダの値が必要なので、contents配列を展開して渡す
        query = query.joins("INNER JOIN profile_values AS #{alias_name_of_profile_values}
                            ON #{alias_name_of_profile_values}.member_id = members.id")
                     .where(final_conditions, field, *contents)
      else
        query = query.joins("INNER JOIN profile_values AS #{alias_name_of_profile_values}
                            ON #{alias_name_of_profile_values}.member_id = members.id")
                     .where("#{alias_name_of_profile_values}.profile_field_id= ?
                            AND #{alias_name_of_profile_values}.content LIKE ?", field, "%#{content}%")
      end
    end
    # 重複を排除して結果を返す
    query.distinct
  end


  def change_date_format(profile_field_id,content)
    return false unless profile_field_id && content
    profile_field=ProfileField.find_by(id:profile_field_id)
    if profile_field && profile_field.name == "生年月日"
      content.gsub("/","-")
    else
      content
    end
  end
end

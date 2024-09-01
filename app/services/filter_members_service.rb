class FilterMembersService
  def self.call(params)
    new(params).call
  end

  def initialize(params)
    @params = params
  end

  def call
    scattered_profile_params=@params.select{|key,_|key.match?(/field\d/) || key.match?(/value\d/)}
    grouped_pairs_params=group_by_profile_pairs(scattered_profile_params)
    filter_members(grouped_pairs_params)
  end


  private
  # scatterd_profile_params={field1:1,value1:"",field2:"",value2:""}
  # => {:profile1=>{:field=>nil, :value=>nil},
  #     :profile2=>{:field=>nil, :value=>nil}}
  def group_by_profile_pairs(params)
    params_size=params.to_h.size/2
    grouped_pairs_params={}
    # field1,value1,field2,value2というように並んでいるので、サイズ÷２回で、１ペアあるものと認識する
    if params_size < 2
      field=params["field1"]
      value="%#{params["value1"]}%"
      pairs_params={"profile1".to_sym=>{field:,value:}}
      grouped_pairs_params.merge!(pairs_params)
    else
      params_size.times do |i|
        field=params["field#{i+1}"]
        value=params["value#{i+1}"]
        pairs_params={"profile#{i+1}".to_sym=>{field:,value:}}
        grouped_pairs_params.merge!(pairs_params)
      end
    end
    return grouped_pairs_params
  end


  def filter_members(params)
    # これに、複数のクエリを追加していく
    query=Member


    # paramsの個数（{profile1:{field:"",value:""},profile2,,,,}）分繰り返す
    params.each_with_index do |(_, value),i|
      # paramsから項目（profile_field.id）と内容（profile_value.content）を読み取る
      field = value[:field].to_i
      content = value[:value]

      # if content.include？("、")

      # 異なるprofile_field_idの条件でAND検索するため、項目条件の個数分membersとprofile_valuesを内部結合する
      alias_name_of_profile_values="profile_values#{i+1}" #複数回結合する際、テーブルを識別する必要があるため
      query=query.joins("INNER JOIN profile_values AS #{alias_name_of_profile_values} ON #{alias_name_of_profile_values}.member_id = members.id")
                 .where("#{alias_name_of_profile_values}.profile_field_id= ? AND #{alias_name_of_profile_values}.content LIKE ?",field,"%#{content}%")
    end

    # 重複を排除して結果を返す
    members=query.distinct
    members
  end
end

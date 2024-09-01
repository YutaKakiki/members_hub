require 'rails_helper'

RSpec.describe 'FilterMembersService' do
  describe "call" do
    let(:team){create(:team) }
    let(:one_name_pair_params){{"field1" => 1, "value1" => "Example User30" }}
    let(:two_name_pair_params){{"field1" => 1, "value1" => "Example User","field2"=>3,"value2"=>"内容30" }}
    let(:one_name_pair_params_includ_comma){{"field1" => 2, "value1" => "内容29、内容30" }}
    context 'paramsの数でAND検索をしてvaliue内に「、」があった場合はOR検索にすることに' do
      before do
        set_up_all_data(team)
      end
      it '成功する' do
        puts Member.first.user.name
        # feldとvalueの引数のペアをparamsから受け取ると[field（項目名）]が[value(内容)]のMemberを返す
        service=FilterMembersService.new(one_name_pair_params)
        members=service.call
        expect(members.count).to eq 1   # Example User30であるメンバーは唯一一人
        expect(members.first.profile_values.first.content).to eq("Example User30")
        # fieldとvalueの引数のペアが複数あった場合、[field（項目名）]=[value(内容)]の条件をAND検索したMemberを返す
        service=FilterMembersService.new(two_name_pair_params) #Example Userだけなら複数ヒットするが、項目２が「内容３０」のメンバーにフィルタリング
        members=service.call
        expect(members.count).to eq 1
        expect(members.first.profile_values.first.content).to eq("Example User30")
        # # fieldとvalueペアが1つで、valueに「A、B」を含んでいた場合[field（項目名）]=[value(内容)]の条件をOR検索したMemberを返す
        service=FilterMembersService.new(one_name_pair_params_includ_comma)
        members=service.call
        expect(members.count).to eq 2
        expect(members.first.profile_values.first.content).to eq("Example User29")
        expect(members.second.profile_values.first.content).to eq("Example User30")
      end
    end
  end
end

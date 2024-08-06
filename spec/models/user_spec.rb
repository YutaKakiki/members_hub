require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:team) { create(:team) }
  context 'ユーザーがチームのメンバーとなると' do
    before do
      @member = user.members.create({ team_id: team.id })
    end
    it 'membersテーブルにuser_idとteam_idが入る' do
      expect(@member.user.name).to eq 'Example User'
      expect(@member.team.name).to eq 'Example Team'
    end
    it 'ユーザーから所属チームを取得できる' do
      expect(user.teams.last.name).to eq 'Example Team'
    end
  end
  context 'ユーザーがチームの管理者となると（実際にはチーム作成時に管理者となる）' do
    before do
      @admin = user.admins.create({ team_id: team.id })
    end
    it 'adminsテーブルにuser_idとteam_idが入る' do
      expect(@admin.user.name).to eq 'Example User'
      expect(@admin.team.name).to eq 'Example Team'
    end
  end
end

require 'rails_helper'

RSpec.describe Team, type: :model do
  let(:team) { create(:team) }
  context 'Teamは、メンバー（ユーザー）が参加していれば' do
    before do
      # ユーザーを十人用意
      10.times do
        create(:user, :multiple)
      end
      users = User.limit(10)
      # ユーザーを全員Example Teamのメンバーにする
      users.each do |user|
        user.members.create({ team_id: team.id })
      end
    end
    after do
      User.destroy_all
    end
    it 'そのユーザーをすべて取得できる' do
      members = team.member_users
      members.each_with_index do |member, i|
        expect(member.name).to eq("Example User#{i + 1}")
      end
    end
  end
  context 'Teamは、管理者が一人いれば' do
    let(:user) { create(:user) }
    before do
      user.admins.create({ team_id: team.id })
    end
    it 'その管理者を一人取得すること取得することができる' do
      expect(team.admin_user.name).to eq 'Example User'
    end
  end
end

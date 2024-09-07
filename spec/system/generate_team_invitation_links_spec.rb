require 'rails_helper'

RSpec.describe "GenerateTeamInvitationLinks", type: :system do
  let(:team) { create(:team) }
  let(:current_user) { create(:user, :authenticated) }
  before do
    Admin.set_as_admin(current_user,team)
    sign_in current_user
    visit users_admins_teams_path
  end
  context "初めて管理者が招待リンクを生成ボタンを押した時" do
    it 'URLが正常に生成される' do
      expect{click_link "招待リンクを生成"}.to change(TeamInvitation,:count).from(0).to(1)
    end
  end
  context "有効期限内(24時間以内)に管理者が招待リンクを生成ボタンを押した時" do
    before do
      team.create_team_invitation(invitation_digest:"digest",expires_at:24.hours.from_now)
    end
    it 'URLが正常に生成されず、同様のURLが表示される' do
      travel_to(2.hours.from_now) do
        expect{click_link "招待リンクを生成"}.not_to change(TeamInvitation,:count)
      end
    end
  end
  context "有効期限を過ぎてから管理者が招待リンクを生成ボタンを押した時" do
    before do
      team.create_team_invitation(invitation_digest:"digest",expires_at:24.hours.from_now)
    end
    it 'URLが正常に生成される（アップデートされる）' do
      travel_to(2.days.from_now) do
        expect{click_link "招待リンクを生成"}.to change{TeamInvitation.last.updated_at}
      end
    end
  end
end

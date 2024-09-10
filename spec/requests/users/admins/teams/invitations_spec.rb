require 'rails_helper'

RSpec.describe 'Users::Admins::Teams::Invitations', type: :request do
  let(:team) { create(:team) }
  let(:current_user) { create(:user, :authenticated) }
  let(:expected_token) { 'expected_token_value' }
  let(:expected_updated_token) { 'expected_updated_token_value' }
  context '初めて管理者が招待リンクを生成ボタンを押した時' do
    before do
      # create_tokenは、常にexpected_token
      allow(TeamInvitation).to receive(:create_token).and_return(expected_token)
    end
    it 'URLが正常に生成される' do
      get users_admins_teams_invitation_path(team_id: team.uuid)
      expect(response.body).to include("http://www.example.com/teams/invitation?team_id=#{team.uuid}&amp;token=#{expected_token}")
    end
  end
  context '有効期限内(24時間以内)に管理者が招待リンクを生成ボタンを押した時' do
    before do
      allow(TeamInvitation).to receive(:create_token).and_return(expected_token)
      get users_admins_teams_invitation_path(team_id: team.uuid)
    end
    it 'URLが正常に生成されず、同様のURLが表示される' do
      travel_to(2.hours.from_now) do
        get users_admins_teams_invitation_path(team_id: team.uuid)
        expect(response.body).to include("http://www.example.com/teams/invitation?team_id=#{team.uuid}&amp;token=#{expected_token}")
      end
    end
  end
  context '有効期限を過ぎてから管理者が招待リンクを生成ボタンを押した時' do
    before do
      allow(TeamInvitation).to receive(:create_token).and_return(expected_token)
      get users_admins_teams_invitation_path(team_id: team.uuid)
    end

    it 'URLが正常に生成される（アップデートされる）' do
      allow(TeamInvitation).to receive(:create_token).and_return(expected_updated_token)
      travel_to(2.days.from_now) do
        get users_admins_teams_invitation_path(team_id: team.uuid)
        expect(response.body).to include("http://www.example.com/teams/invitation?team_id=#{team.uuid}&amp;token=#{expected_updated_token}")
      end
    end
  end
end

require 'rails_helper'

RSpec.describe 'AuthenticationAndAuthorizations', type: :system do
  let(:team) { create(:team) }
  context 'ログインしていないユーザーが' do
    it 'メンバー一覧ページに入るとログイン画面にリダイレクトする' do
      visit team_members_path(team.uuid)
      expect(current_path).to eq new_user_session_path
      expect(page).to have_content 'ログインもしくはアカウント登録してください。'
    end
    it '参加しているチーム一覧ページに入るとログイン画面にリダイレクトする' do
      visit users_members_teams_path
      expect(current_path).to eq new_user_session_path
      expect(page).to have_content 'ログインもしくはアカウント登録してください。'
    end
    it '管理しているチーム一覧ページに入るとログイン画面にリダイレクトする' do
      visit users_admins_teams_path
      expect(current_path).to eq new_user_session_path
      expect(page).to have_content 'ログインもしくはアカウント登録してください。'
    end
    it 'チーム作成ページに入るとログイン画面にリダイレクトする' do
      visit new_team_path
      expect(current_path).to eq new_user_session_path
      expect(page).to have_content 'ログインもしくはアカウント登録してください。'
    end
    it 'チーム参加ページに入るとログイン画面にリダイレクトする' do
      visit new_users_member_path
      expect(current_path).to eq new_user_session_path
      expect(page).to have_content 'ログインもしくはアカウント登録してください。'
    end
    it 'チーム参加ページに入るとログイン画面にリダイレクトする' do
      visit new_users_member_path
      expect(current_path).to eq new_user_session_path
      expect(page).to have_content 'ログインもしくはアカウント登録してください。'
    end
  end

  let(:user) { create(:user, :authenticated) }
  let(:other_user) { create(:user, :multiple) }
  let(:member) { create(:member, team:, user: other_user) }
  context 'チームのメンバーでないユーザーが' do
    before do
      sign_in user
    end
    it 'チーム一覧ページに入ると、チームに参加するページにリダイレクトする' do
      visit team_members_path(team.uuid)
      expect(current_path).to eq new_users_member_path
      expect(page).to have_content 'チームに参加してください'
    end
    it '特定のメンバーのプロフィール詳細画面(モーダル)に入ると、チームに参加するページにリダイレクトする' do
      visit team_member_path(team.uuid, member.id)
      expect(current_path).to eq new_users_member_path
      expect(page).to have_content 'チームに参加してください'
    end
  end

  context 'そのメンバーでないユーザーがプロフィールを編集しようとすると' do
    before do
      sign_in user
      Member.join_team(user, team)
    end
    it 'ルートパスにリダイレクトする' do
      visit edit_users_members_profile_value_path(member.id)
      expect(current_path).to eq root_path
      expect(page).to have_content '他のメンバーの情報は変更できません'
    end
  end

  context 'チームの管理者でないユーザーが' do
    before do
      sign_in user
      Admin.set_as_admin(other_user, team)
    end
    it 'チーム編集画面にアクセスするとリダイレクトする' do
      visit edit_team_path(team.uuid)
      expect(current_path).to eq root_path
      expect(page).to have_content 'チームの管理者権限が必要です'
    end
    it 'プロフィール項目編集にアクセスするとリダイレクトする' do
      visit teams_profile_fields_path(team_id: team.uuid)
      expect(current_path).to eq root_path
      expect(page).to have_content 'チームの管理者権限が必要です'
    end
    it '招待リンクの生成画面にアクセスするとリダイレクトする' do
      visit users_admins_teams_invitation_path(team_id: team.uuid)
      expect(current_path).to eq root_path
      expect(page).to have_content 'チームの管理者権限が必要です'
    end
  end
end

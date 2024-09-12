require 'rails_helper'

RSpec.describe 'Teams::Invitations', type: :request do
  let(:team) { create(:team) }
  let(:user) { create(:user, :authenticated) }
  let(:expected_token) { 'expected_token_value' }
  before do
    ActionMailer::Base.deliveries.clear
    allow(TeamInvitation).to receive(:create_token).and_return(expected_token)
    Admin.set_as_admin(user, team)
    sign_in user
    get users_admins_teams_invitation_path(team_id: team.uuid)
    sign_out user
  end
  context '招待するユーザーがすでにサービスに登録している時' do
    it 'リンクを踏むと（リクエストを送ると）チーム認証をスキップしてプロフィール登録ページに遷移する' do
      sign_in user
      expect(Member.count).to eq 0
      get teams_invitation_path(token: expected_token, team_id: team.uuid)
      expect(Member.count).to eq 1
      expect(response).to redirect_to new_users_members_profile_value_path(team_id: team.uuid)
    end
  end

  context '招待するユーザーにログインが必要だったとき' do
    it 'リンクを踏むとログインページに遷移し、その後にプロフィール登録ページに遷移する' do
      expect(Member.count).to eq 0
      get teams_invitation_path(token: expected_token, team_id: team.uuid)
      expect(session[:invitation_url]).to eq teams_invitation_url(token: expected_token, team_id: team.uuid)
      expect(response).to redirect_to new_user_session_path
      post user_session_path, params: {
        user: {
          email: user.email,
          password: 'password'
        }
      }
      expect(response).to redirect_to teams_invitation_path(token: expected_token, team_id: team.uuid)
      follow_redirect! # リダイレクト先を追跡
      expect(Member.count).to eq 1
      expect(response).to redirect_to new_users_members_profile_value_path(team_id: team.uuid)
    end
  end

  context '招待するユーザーが未登録であったとき' do
    it '新規登録を行い、本人確認をした後にプロフィール登録ページに遷移する' do
      expect(Member.count).to eq 0
      get teams_invitation_path(token: expected_token, team_id: team.uuid)
      expect(session[:invitation_url]).to eq teams_invitation_url(token: expected_token, team_id: team.uuid)
      post user_registration_path, params: {
        user: {
          name: 'ユーザー',
          email: 'example@email.com',
          password: 'password',
          password_confirmation: 'password'
        }
      }
      expect(ActionMailer::Base.deliveries.size).to eq 1
      # 送信されたメールを取得
      confirmation_email = ActionMailer::Base.deliveries.last
      email_body = confirmation_email.body.encoded
      # メールのリンクからトークンを抽出する
      # ここでは正規表現を使用してトークンを抽出（キャプチャグループの1つ目）
      confirmation_token = email_body.match(/confirmation_token=(\w+)/)[1]
      get user_confirmation_path(confirmation_token:)
      # FIXME: 以下の一行が割と不安定...５回に一回はresponseが200OKになる
      expect(response).to redirect_to teams_invitation_path(token: expected_token, team_id: team.uuid)
      follow_redirect!
      expect(response).to redirect_to new_users_members_profile_value_path(team_id: team.uuid)
      expect(Member.count).to eq 1
    end
  end

  context '招待リンクが有効期限切れだった時' do
    it 'ルートパスにリダイレクトされる' do
      sign_in user
      travel_to(2.days.from_now) do
        get teams_invitation_path(token: expected_token, team_id: team.uuid)
        expect(response).to redirect_to root_path
        expect(Member.count).to eq 0
      end
    end
  end
  context '招待リンクのトークンが無効だった時' do
    it 'ルートパスにリダイレクトされる' do
      sign_in user
      get teams_invitation_path(token: 'invalid_token', team_id: team.uuid)
      expect(response).to redirect_to root_path
      expect(Member.count).to eq 0
    end
  end
end

require 'rails_helper'

RSpec.describe "Teams::Invitations", type: :request do
  let(:team){create(:team)}
  let(:user){create(:user,:authenticated)}
  context "招待するユーザーがすでにサービスに登録している時" do
    it "リンクを踏むと（リクエストを送ると）チーム認証をスキップしてプロフィール登録ページに遷移する" do
      expect(Member.count).to 0
      post teams_invitation_path(team_id:team.uuid)
      expect(Member.count).to 1
      expect(response).to redirect_to new_users_members_profile_value_path
    end
  end
  context "招待するユーザーにログインが必要だったとき" do
    it "リンクを踏むとログインページに遷移し、その後にプロフィール登録ページに遷移する" do
      expect(Member.count).to 0
      post teams_invitation_path(team_id:team.uuid)
      expect(Member.count).to 1
      expect(response).to redirect_to new_user_session_path
      post user_session_path,params:{
        user: {
          email: user.email,
          password: "password"
        }
      }
      expect(response).to redirect_to new_users_members_profile_value_path
    end
  end
end

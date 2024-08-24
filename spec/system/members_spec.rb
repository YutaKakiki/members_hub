require 'rails_helper'

RSpec.describe 'Members', type: :system do
  context "既存のチームのID・パスワードを正しく入力したとき" do
    let(:team){create(:team)}
    let(:user){create(:user,:authenticated)}
    before do
      sign_in user
      click_link "チームに参加"
    end
    it '正常に所属が完了しメンバーとなる' do
      expect(current_path).to eq new_members_joins_path
      expect(page).to have_selector "form"
      fill_in "チームID",	with: team.uuid
      fill_in "チームパスワード",	with: team.password
      click_button "次へ"
      # member/new.member_profile.html.erbにリダイレクト
      expect(current_path).to eq new_members_profiles_path
      expect(page).to have_http_status(:redirect)
      expect(page).to have_content "プロフィールを入力"
      expect(page).to have_content "参加するチーム"
      expect(page).to have_content team.name
    end
  end
  context '既存チームのメンバー認証に成功したが、プロフィールを作成しなかった場合' do
    it 'メンバーの登録は削除される' do
      fill_in 'チームID',	with: team.uuid
      fill_in 'パスワード',	with: 'password'
      expect { click_button '次へ' }.to change { Member.count }.by(1)
      expect(current_path).to eq new_users_members_profile_value_path
      # プロフィールを作成せずにroot_pathへ意図的に移動
      click_link 'Members Hub'
      Member.last
      # membersテーブルへの登録が削除されている
      expect(Member.count).to eq 0
    end
  end
end

require 'rails_helper'

RSpec.describe "TeamProfiles", type: :system do
  let(:user) { create(:user, :authenticated) }
  before do
    sign_in user
    visit root_path
    click_link 'チームを作成'
    fill_in 'チーム名',	with: 'Example Team'
    fill_in 'チームパスワード', with: 'password'
    fill_in '確認用パスワード', with: 'password'
    click_button "次へ"
  end
  context "管理者がチームのプロフィールを登録すること" do
    it '成功する' do
      # プロフィール設定ページにリダイレクト
      expect(current_path).to eq new_teams_profile_field_path
      expect(page).to have_content "プロフィール項目を設定"
      # 以下二つはデフォルトで追加
      expect(page).to have_content "名前"
      expect(page).to have_content "生年月日"
      expect(page).to have_selector "form"
      expect(page).to have_button "追加"
      # 上記項目以外は追加項目として登録
      fill_in "項目",with: "ニックネーム"
      click_button "追加"
      expect(page).to have_content "ニックネーム"
      team_profile_field_count=Team.last.profile_fields.count
      expect(team_profile_field_count).to eq 3
      # 実際は、「完了」ボタンを押して遷移
      visit users_admins_teams_path
      expect(page).to have_content "Example Team がチームとして正常に作成されました"
    end
  end
end

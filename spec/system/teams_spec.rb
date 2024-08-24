require 'rails_helper'

RSpec.describe 'Teams', type: :system do
  context 'ユーザーがチームを登録すると' do
    let(:user) { create(:user, :authenticated) }
    let(:other_user) { create(:user, :authenticated, email: 'test2@example.com') }
    before do
      sign_in user
      visit root_path
      click_link 'チームを作成'
      fill_in 'チーム名',	with: 'Example Team'
      fill_in 'チームパスワード', with: 'password'
      fill_in '確認用パスワード', with: 'password'
    end
    it 'チームが正常に作成されている' do
      expect(page).to have_link 'チームを作成'
      expect(page).to have_selector 'form'
      expect { click_button '次へ' }.to change { Team.count }.by(1)
      expect(page).to have_http_status(:success)
    end
    it 'そのユーザがチームの管理者となっている' do
      click_button '次へ'
      created_team = Team.last
      expect(created_team.admin_user.name).to eq user.name
    end
    it 'プロフィールの登録ページに遷移する' do
      click_button '次へ'
      expect(current_path).to eq new_teams_profile_field_path
    end
  end
end

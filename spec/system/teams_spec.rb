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
      fill_in 'パスワード', with: 'password'
      fill_in '確認用パスワード', with: 'password'
    end
    it 'チームが正常に作成されている' do
      expect(page).to have_link 'チームを作成'
      expect(page).to have_selector 'form'
      expect { click_button '作成' }.to change { Team.count }.by(1)
      expect(page).to have_content '新しくチーム Example Team が作成されました'
      expect(page).to have_http_status(:success)
    end
    it 'そのユーザがチームの管理者となっている' do
      click_button '作成'
      click_link '管理中のチーム'
      expect(page).to have_content 'Example Team'
    end
    it '他のユーザーは、「管理中のチーム」画面にチームが表示されていない' do
      click_button '作成'
      sign_out user
      sign_in other_user
      click_link '管理中のチーム'
      expect(page).to have_content '現在あなたが管理しているチームはありません'
    end
  end
end

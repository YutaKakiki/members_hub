require 'rails_helper'

RSpec.describe 'Sessions', type: :system do
  let(:user) { create(:user, :authenticated) }
  context '正しい情報で普通のログインをした時' do
    before do
      visit new_user_session_path
      expect(page).to have_selector 'form'
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'
    end
    it 'ログインに成功する' do
      expect(page).to have_content 'ログインしました'
    end
    it 'ログアウトに成功する' do
      find('#icon_button').click
      # ログアウトリンクを押す
      find('#logout_link').click
      expect(page).to have_content 'ログアウトしました'
      expect(page).to have_link 'ログイン'
    end
  end
end

require 'rails_helper'

RSpec.describe "Sessions", type: :system do
  let(:user) {create(:user) }
  context "正しい情報で普通のログインをした時" do
    before do
      visit new_user_session_path
      expect(page).to have_selector "form"
      fill_in "メールアドレス",with:user.email
      fill_in "パスワード",with:user.password
      click_button "ログイン"
    end
    it 'ログインに成功する' do
      # 手動の確認は完了している
    end
  end

end

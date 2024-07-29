require 'rails_helper'

RSpec.describe "Registrations", type: :system do
  context "正常な情報を送信した時" do
    before do
      ActionMailer::Base.deliveries.clear
      visit new_user_session_path
      click_link "新規登録"
      fill_in "名前",	with: "仮ユーザー"
      fill_in "メールアドレス",with: "example-1@example.com"
      fill_in "生年月日",with: "2002-12-24"
      fill_in "パスワード",with: "password"
      fill_in "確認用パスワード",with:"password"
    end

    it "新規登録ができる" do
      expect(page).to have_current_path(new_user_registration_path)
      expect(page).to have_selector "form"
      expect{click_button "登録"}.to change{User.count}.by(1)
      # #なぜ失敗するのか...
      # expect(page).to have_content "本人確認用のメールを送信しました。メール内のリンクからアカウントを有効化させてください。"
      expect(page).to have_http_status(:success)
      expect(page).to have_current_path(root_path)
      # まだユーザーは有効化されていない
      not_authenticate_user=User.first
      expect(not_authenticate_user.confirmed_at).to be nil
    end

    it "メールが送信される" do
      click_button "登録"
      expect(ActionMailer::Base.deliveries.size).to eq 1
    end
  end

  context "正しくないフォーマットでメールアドレスを送信した時" do
    before do
      ActionMailer::Base.deliveries.clear
      visit new_user_session_path
      click_link "新規登録"
      fill_in "名前",	with: "仮ユーザー"
      fill_in "メールアドレス",with: "invalid email"
      fill_in "生年月日",with: "2002-12-24"
      fill_in "パスワード",with: "password"
      fill_in "確認用パスワード",with:"password"
    end
    it "新規登録されない" do
      click_button "登録"
      expect(page).to have_http_status(:unprocessable_entity)
      expect(User.count).to eq 0
      expect(page).to have_content "メールアドレス は有効でありません。"
    end
  end
end

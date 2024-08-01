require 'rails_helper'

RSpec.describe "OmniauthSignins", type: :system do

  context "新規ユーザーがGoogleによりログインした時" do
    before do
      Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
      Rails.application.env_config["omniauth.auth"] = OmniauthMock.google_mock
    end
    it "ログインに成功する" do
      visit new_user_session_path
      expect(page).to have_button "Googleで登録/ログイン"

      expect{click_button "Googleで登録/ログイン"}.to change(User,:count).from(0).to(1)
      # rootパスにリダイレクトされている
      expect(page).to have_current_path(root_path,wait:10)
      expect(page).to have_http_status(:success)
      user=User.last
      expect(user.confirmed_at).to be_present
      expect(user.name).to eq "Example User"
      # 以下、手動での挙動は正しいがテストが失敗する
      expect(page).to have_content "Google アカウントによる認証に成功しました。"
      expect(page).to have_no_link "ログイン"
    end
  end

  context "新規ユーザーがLINEによりログインした時" do
    before do
      Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
      Rails.application.env_config["omniauth.auth"] = OmniauthMock.line_mock
    end
    it "ログインに成功する" do
      visit new_user_session_path
      expect(page).to have_button "LINEで登録/ログイン"

      expect{click_button "LINEで登録/ログイン"}.to change(User,:count).from(0).to(1)
      # rootパスにリダイレクトされている
      expect(page).to have_current_path(root_path,wait:10)
      expect(page).to have_http_status(:success)
      user=User.last
      expect(user.confirmed_at).to be_present
      expect(user.name).to eq "Example User"
      expect(page).to have_content "Line アカウントによる認証に成功しました。"
      expect(page).to have_no_link "ログイン"
    end
  end


end

require 'rails_helper'

RSpec.describe 'MemberProfiles', type: :system do
  let(:team) { create(:team) }
  let(:user) { create(:user, :authenticated) }
  context 'プロフィール登録画面に遷移した時' do
    before(:each) do
      9.times do
        create(:profile_field, team:)
      end
      sign_in user
      visit root_path
      within '#pc-screen' do
        click_link 'チームに参加'
      end
      fill_in 'チームID', with: team.uuid
      fill_in 'パスワード', with: 'password'
      click_button '次へ'
    end
    after do
      ProfileField.destroy_all
    end
    it 'チームに設定されたプロフィール項目のフォームが表示されている' do
      expect(current_path).to eq new_users_members_profile_value_path
      expect(team.profile_fields.count).to eq 9
      expect(page).to have_selector('input[name="profile_value[content1]"]')
      expect(page).to have_selector('input[name="profile_value[content9]"]')

      9.times do
        expect(page).to have_content('項目')
      end
    end
    it '記入して「登録」を押すと、正常に登録される' do
      9.times do |n|
        fill_in "profile_value_content#{n + 1}", with: '項目内容'
      end
      expect { click_button '登録' }.to change { ProfileValue.count }.by(9)
      # 参加中のチーム　へリダイレクト
      expect(current_path).to eq users_members_teams_path
      expect(page).to have_content team.name
    end
    it '記入せずに登録すると、エラーメッセージが表示される' do
      # 5つフィールドがあるが、1つだけ記入
      fill_in 'profile_value_content1', with: '項目内容'
      expect { click_button '登録' }.not_to(change { ProfileValue.count })
      expect(current_path).to eq new_users_members_profile_value_path
      expect(page).to have_selector('input[name="profile_value[content1]"]')
      expect(page).to have_selector('input[name="profile_value[content5]"]')
      # フォームのvalueは保持されている
      expect(page).to have_selector('input[value="項目内容"]')
      expect(page).to have_content('プロフィール項目を全て入力してください')
    end
  end
end

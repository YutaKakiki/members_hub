require 'rails_helper'

RSpec.describe "MemberProfiles", type: :system do
    let(:team){create(:team)}
    let(:user){create(:user,:authenticated)}
  context "プロフィール登録画面に遷移した時" do
    before do
      5.times do
        create(:profile_field,team:team)
      end
      sign_in user
      visit root_path
      click_link "チームに参加"
      fill_in 'チームID', with: team.uuid
      fill_in 'パスワード', with: 'password'
      click_button "次へ"
    end
    it 'チームに設定されたプロフィール項目のフォームが表示されている' do
      expect(current_path).to eq new_users_members_profile_value_path
      expect(team.profile_fields.count).to eq 5
      expect(page).to have_selector('input[name="profile_value[content_1]"]')
      expect(page).to have_selector('input[name="profile_value[content_5]"]')

      5.times do |n|
        expect(page).to have_content("項目#{n+1}")
      end
    end
    it '記入して「登録」を押すと、正常に登録される' do
      5.times do |n|
        fill_in "profile_value_content_#{n+1}", with: "項目内容"
      end

      member=user.members.last
      expect{click_button "登録"}.to change{member.profile_values.count}.by(5)
      # 参加中のチーム　へリダイレクト
      expect(current_path).to eq users_members_teams_path
      expect(page).to have_content team.name
    end
  end

end

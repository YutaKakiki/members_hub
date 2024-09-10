require 'rails_helper'

RSpec.describe 'TeamMembersViewings', type: :system do
  context '「メンバーを閲覧」を押して、チームを選択すると' do
    let(:team) { create(:team) }
    let(:current_user) { create(:user, :authenticated) }
    before do
      # チームのプロフィール項目を作成
      name_field = create(:profile_field, :name, team:)
      birth_field = create(:profile_field, :birth, team:)
      7.times do
        create(:profile_field, team:)
      end
      custom_profile_fields = ProfileField.limit(3).offset(2)
      # カレントユーザーをチームへ登録
      current_member = create(:member, team:, user: current_user)
      # カレントユーザーのプロフィールを登録
      create(:profile_value, :name, member: current_member, profile_field: name_field)
      create(:profile_value, :birth, member: current_member, profile_field: birth_field)
      custom_profile_fields.map do |custom_profile_field|
        create(:profile_value, member: current_member, profile_field: custom_profile_field)
      end
      # カレントユーザーにログインさせる
      sign_in current_user
      visit root_path
      # 30人分のメンバーを用意
      30.times do
        create(:user, :multiple)
      end
      users = User.limit(30)
      users.map do |user|
        create(:member, user:, team:)
      end
      # 30人のメンバープロフィールを登録
      members = Member.limit(30)
      members.map do |member|
        create(:profile_value, :name, member:, profile_field: name_field)
        create(:profile_value, :birth, member:, profile_field: birth_field)
        custom_profile_fields.map do |custom_profile_field|
          create(:profile_value, member:, profile_field: custom_profile_field)
        end
      end
    end
    after do
      User.destroy_all
      ProfileField.destroy_all
      Member.destroy_all
      ProfileValue.destroy_all
    end
    it 'チームのメンバーが全て表示される' do
      find("div[id='pc_screen_member_viewing_button']", text: 'メンバーを閲覧')
      expect(page).to have_link team.name
      # レスポンシブにしたせいでhiddenも認識してしまう
      # click_link team.name
      visit team_members_path(team.uuid)
      expect(current_path).to eq team_members_path(team.uuid)
      expect(page).to have_content team.name
      # ページネーションにより最初の10件のみ表示される
      members = Member.limit(10)
      members.each do |member|
        expect(page).to have_content member.profile_values.first.content
      end
    end
    it 'チームメンバー個々の詳細を確認できる' do
      find("div[id='pc_screen_member_viewing_button']", text: 'メンバーを閲覧')
      # click_link team.name
      visit team_members_path(team.uuid)
      member = Member.first
      # 名前の部分をクリック（正確にはカード内のどこででもいい）
      click_link "member-link-#{member.id}"
      # プロフィール項目が全て表示されている
      team.profile_fields.each do |profile_field|
        expect(page).to have_content(profile_field.name) unless profile_field.name == '名前'
      end
    end
  end
end

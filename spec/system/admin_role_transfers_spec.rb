require 'rails_helper'

RSpec.describe "AdminRoleTransfers", type: :system do
  let(:team) { create(:team) }
  let(:current_user) { create(:user, :authenticated) }
  before do
    setup_all_data(team)
    # 追加項目のフィールド
    custom_profile_fields = ProfileField.limit(3).offset(2)
    name_field = ProfileField.first
    birth_field = ProfileField.second
    # カレントユーザーをメンバー登録
    current_member = create(:member, user: current_user, team:)
    # カレントユーザーのプロフィールを登録
    create(:profile_value, :name, member: current_member, profile_field: name_field)
    create(:profile_value, :birth, member: current_member, profile_field: birth_field)
    custom_profile_fields.map do |custom_profile_field|
      create(:profile_value, member: current_member, profile_field: custom_profile_field)
    end
    # カレントユーザーにログインさせる
    sign_in current_user
    # カレントユーザーにAdminをセットする(本来はチーム作成時にセットされる)
    Admin.set_as_admin(current_user,team)
    visit root_path
    visit team_members_path(team.uuid)
  end
  after do
    User.destroy_all
    ProfileField.destroy_all
    Member.destroy_all
    ProfileValue.destroy_all
  end
  context "メンバー詳細を閲覧した時" do
    it '「管理者にする」ボタンが表示されている（自分以外）' do

      member = Member.first
      current_member=Member.find_by(user_id:current_user.id)
      # 名前の部分をクリック（正確にはカード内のどこででもいい）
      click_link "member-link-#{member.id}"
      expect(page).to have_link "管理者にする"
      # リロード
      visit team_members_path(team.uuid)
      click_link "last-page-link"
      # 管理者である自分は表示されていない
      click_link "member-link-#{current_member.id}"
      expect(page).to have_no_link "管理者にする"
    end
    it "管理者でないユーザーには「管理者にする」ボタンが表示されない" do

      not_admin_user = User.first
      not_admin_user.confirmed_at=Time.now
      sign_in not_admin_user
      visit team_members_path(team.uuid)
      other_member=Member.second
      click_link "member-link-#{other_member.id}"
      expect(page).to have_no_link "管理者にする"
    end
    it "「管理者にする」ボタンを押すとカレントユーザーの管理者権限が消え、指定したユーザーに権限が譲渡される" do
      successor_member = Member.first
      # この段階ではカレントユーザーが管理者
      expect(team.admin_user).to eq current_user
      click_link "member-link-#{successor_member.id}"
      expect{click_link "管理者にする"}.to change{Admin.first.user_id}.from(current_user.id).to(successor_member.user.id)
      expect(current_path).to eq team_members_path(team.uuid)
      expect(page).to have_content "#{team.name} の管理者を #{successor_member.profile_values.first.content} に変更しました"
      visit users_admins_teams_path
      expect(page).to have_content "現在あなたが管理しているチームはありません"
    end
  end
end

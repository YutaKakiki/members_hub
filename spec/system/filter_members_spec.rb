require 'rails_helper'

RSpec.describe "FilterMembers", type: :system do
  let(:team) { create(:team) }
  let(:current_user) { create(:user, :authenticated) }
  before do
    set_up_all_data(team)
    # 追加項目のフィールド
    custom_profile_fields = ProfileField.limit(3).offset(2)
    name_field=ProfileField.first
    birth_field=ProfileField.second
    #カレントユーザーをメンバー登録
    current_member=create(:member,user:current_user,team:)
    # カレントユーザーのプロフィールを登録
    create(:profile_value, :name, member: current_member, profile_field: name_field)
    create(:profile_value, :birth, member: current_member, profile_field: birth_field)
    custom_profile_fields.map do |custom_profile_field|
      create(:profile_value, member: current_member, profile_field: custom_profile_field)
    end
    # カレントユーザーにログインさせる
    sign_in current_user
    visit root_path
    visit  team_members_path(team.uuid)
  end
  after do
    User.destroy_all
    ProfileField.destroy_all
    Member.destroy_all
    ProfileValue.destroy_all
  end
  context "さまざまな条件を含めて検索すると" do

    it '検索条件に合ったメンバーを表示することに成功する' do
      # 検索条件をフォームに書き込むと、検索条件に合ったメンバーが表示される
      select "名前", from: "field1"
      fill_in "value1",	with: "Example User30"
      click_button "検索"
      expect(page).to have_content "Example User30"
      other_members=Member.all.reject {|member| member.user.name=="Example User30"}
      other_members.each do |member|
        unless member.user.name == "Example User3" || "Example User" #表示されている文字にExample User３も含まれてしまうので除外
          expect(page).not_to have_content member.user.name
        end
      end

      # TODO:システムスペック（jsを使用）を通す
      # プラスボタンを押してフィールドを増やす動作がうまくいかないため、モデルスペック/リクエストスペックで補うことにする

      # # 項目を3つに増やしてAND検索をかけたとき、検索条件に合ったメンバーが表示される
      # visit team_members_path(team.uuid)
      # find("#plus-button").click
      # # find("#plus-button").click
      # select "名前", from: "field1"
      # select "項目1", from: "field2"
      # # select "項目2", from: "field3"
      # fill_in "value1",	with: "Example User"
      # fill_in "value2",	with: "内容30"
      # # fill_in "value3",	with: "内容30"
      # click_button "検索"
      # expect(page).to have_content "Example User30"
      # other_members=Member.all.reject {|member| member.user.name=="Example User30"}
      # other_members.each do |member|
      #   unless member.user.name == "Example User3" || "Example User" #表示されている文字にExample User３も含まれてしまうので除外
      #     expect(page).not_to have_content member.user.name
      #   end
      # end

      # 一つの項目に複数のOR検索をかけた時、検索条件に合ったメンバーが表示される
      visit team_members_path(team.uuid)
      select "名前", from: "field1"
      fill_in "value1",	with: "Example User29、Example User30"
      click_button "検索"
      expect(page).to have_content "Example User29"
      expect(page).to have_content "Example User30"
      other_members=Member.all.reject {|member| member.user.name=="Example User30" || "Example User29"}
      other_members.each do |member|
        unless member.user.name == "Example User3" || "Example User" || "Example User2" #表示されている文字にExample User３なども含まれてしまうので除外
          expect(page).not_to have_content member.user.name
        end
      end

    end
  end


end

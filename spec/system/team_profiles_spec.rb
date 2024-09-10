require 'rails_helper'

RSpec.describe 'TeamProfiles', type: :system do
  let(:user) { create(:user, :authenticated) }
  before do
    sign_in user
    visit root_path
    within '#pc-screen' do
      click_link 'チームを作成'
    end
    fill_in 'チーム名',	with: 'Example Team'
    fill_in 'チームパスワード', with: 'password'
    fill_in '確認用パスワード', with: 'password'
  end
  context 'チームのプロフィール項目を追加すると' do
    it '項目＆チームを正常に作成できる' do
      click_button '次へ'
      # プロフィール設定ページにリダイレクト
      expect(current_path).to eq new_teams_profile_field_path
      expect(page).to have_content 'プロフィール項目を設定'
      # 以下二つはデフォルトで追加
      expect(page).to have_content '名前'
      expect(page).to have_content '生年月日'
      expect(page).to have_selector 'form'
      expect(page).to have_button '追加'
      # 項目を追加していないと、「完了」ボタンがない
      expect(page).to have_no_link '完了'
      # 何も追加していないとカウンターは０
      expect(page).to have_content "追加した項目数：\n0"
      # 上記項目以外は追加項目として設定
      fill_in '項目', with: 'ニックネーム'
      click_button '追加'
      expect(page).to have_content 'ニックネーム'
      expect(page).to have_content '追加した追加した項目数: 1'
      # 実際は、turbo_streamによりリアルタイムに追加されるが、
      # テストだとうまく表示されていないのでリロードして確認することにする
      visit new_teams_profile_field_path(team_id: Team.last.uuid)
      expect(page).to have_content 'ニックネーム'
      expect(page).to have_link('削除', count: 1)
      team_profile_field_count = Team.last.profile_fields.count
      expect(team_profile_field_count).to eq 3
      click_link '完了'
      # 「管理しているチーム」画面に遷移する
      expect(page).to have_content 'Example Team がチームとして正常に作成されました'
      expect(page).to have_content 'Example Team'
    end
  end
  context 'チームのプロフィールを追加せずに中断すると' do
    it 'チームの作成は取り消される' do
      click_button '次へ'
      fill_in '項目', with: '後から削除する項目'
      click_button '追加'
      visit new_teams_profile_field_path(team_id: Team.last.uuid)
      # 作った項目を削除する
      expect { click_link '削除' }.to change(ProfileField, :count).from(3).to(2)
      # 例の如くリロード
      visit new_teams_profile_field_path(team_id: Team.last.uuid)
      expect(page).to have_no_content '後から削除する項目'
      visit root_path
      expect(page).to have_content 'プロフィール項目を設定しなかったため、チームの作成を取消しました'
    end
  end
  context '空文字で追加ボタンを押した時' do
    it 'プロフィール項目は保存されない' do
      click_button '次へ'
      fill_in '項目', with: ''
      expect { click_button '追加' }.not_to change(ProfileField, :count)
      expect(page).to have_content 'エラーが発生したため プロフィール項目 は保存されませんでした。'
      expect(page).to have_content '項目を入力してください'
    end
  end
  context '8つ目の項目を追加しようとした時' do
    it 'エラーメッセージが表示され、追加できない' do
      click_button '次へ'
      team = Team.last
      7.times do
        create(:profile_field, team:)
      end
      # データ操作を後からしたのでリロード
      visit new_teams_profile_field_path(team_id: Team.last.uuid)
      # 項目に付随する削除リンクの数を数える
      # なお、削除ボタンはデフォルト項目には表示されない
      expect(page).to have_link('削除', count: 7)
      fill_in '項目',	with: 'この項目は追加できない'
      expect { click_button '追加' }.not_to change(ProfileField, :count)
      expect(page).to have_content '追加できる項目は7個までです'
    end
  end
end

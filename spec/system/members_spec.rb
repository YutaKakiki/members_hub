require 'rails_helper'

RSpec.describe 'Members', type: :system do
  let(:team) { create(:team) }
  let(:user) { create(:user, :authenticated) }

  before do
    sign_in user
    visit root_path
    click_link 'チームに参加'
    fill_in 'チームID', with: team.uuid
    fill_in 'パスワード', with: 'password'
  end

  context '有効なチームIDとパスワードを入力したとき' do
    it '正常にチームに参加し、メンバーとして登録される' do
      click_button '次へ'
      expect(current_path).to eq new_users_members_profile_value_path
      expect(page).to have_content 'プロフィールを入力'
      expect(page).to have_content team.name
    end
  end

  context 'チームに参加したがプロフィールを作成しなかった場合' do
    it 'メンバーの登録が削除される' do
      expect { click_button '次へ' }.to change { Member.count }.by(1)
      click_link 'Members Hub'
      expect(Member.count).to eq 0
      expect(page).to have_content 'プロフィールを登録しなかったため、チームへの参加を取消しました'
    end
  end
end

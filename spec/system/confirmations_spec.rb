require 'rails_helper'

RSpec.describe 'Confirmations', type: :system do
  before do
    ActionMailer::Base.deliveries.clear
  end

  context '有効化メールのリンクを押した時' do
    let(:user) { FactoryBot.create(:user) }
    let(:mail) { Devise::Mailer.confirmation_instructions(user, user.confirmation_token).deliver_now }
    it 'アカウントが有効化される' do
      # まだ有効化されていない
      expect(user.confirmed_at).to be nil
      expect(mail.subject).to eq 'メールアドレス確認メール'
      open_email(user.email)
      # リンクを踏む
      visit_in_email('メールアドレスの確認', user.email)
      user.reload
      expect(user.confirmed_at).to be_truthy
    end

    it '自動でログインされる' do
      open_email(user.email)
      visit_in_email('メールアドレスの確認', user.email)
      expect(page).to have_current_path(root_path)
      expect(page).to have_no_link 'ログイン'
    end
  end
end

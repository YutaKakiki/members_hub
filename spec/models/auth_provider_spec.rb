require 'rails_helper'

RSpec.describe AuthProvider, type: :model do
  describe '.from_omniauth' do
    let(:user) { create(:user) }
    let(:auth) do
      OmniAuth::AuthHash.new({
        'provider' => 'google_oauth2',
        'uid' => '10000000000',
        'info' => {
          'name' => 'Example User',
          'email' => 'example@example.com'
        }
      })
    end

    context 'プロバイダーとユーザーが既に存在する場合' do
      before do
        create(:auth_provider, user: user, uid: auth.uid, provider: auth.provider)
      end

      it '既存のユーザーを返すこと' do
        result_user = AuthProvider.from_omniauth(auth)
        expect(result_user).to eq(user)
      end
    end

    context 'プロバイダーが存在しない場合' do
      it '新しいユーザーを作成し、それを返す' do
        result_user = AuthProvider.from_omniauth(auth)
        expect(result_user).to be_persisted
        expect(result_user.name).to eq('Example User')
        expect(result_user.email).to eq('example@example.com')
        expect(AuthProvider.exists?(uid: auth.uid, provider: auth.provider)).to be_truthy
      end
    end

    context 'プロバイダーが存在するがユーザーが存在しない場合' do
      before do
        create(:auth_provider, uid: auth.uid, provider: auth.provider)
      end

      it '新しいユーザーを作成し、そのプロバイダーと関連付けること' do
        result_user = AuthProvider.from_omniauth(auth)
        expect(result_user).to be_persisted
        expect(AuthProvider.find_by(uid: auth.uid, provider: auth.provider).user).to eq(result_user)
      end
    end
  end
end

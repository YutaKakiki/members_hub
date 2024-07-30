require 'rails_helper'

RSpec.describe AuthProvider, type: :model do
  describe 'from_omniauth(:google_oauth2)' do
    let(:google_oauth2) { build(:google_oauth2) } # OmniAuthデータを生成
    let(:existing_user) { create(:user) }

    context 'プロバイダーとユーザーが既に存在する場合' do
      before do
        create(:google_oauth2, user: existing_user, uid: google_oauth2['uid'], provider: google_oauth2['provider'])
      end

      it '既存のユーザーを返すこと' do
        result_user = AuthProvider.from_omniauth(google_oauth2)
        expect(result_user).to eq(existing_user)
      end
    end

    context 'プロバイダーが存在しない場合' do
      it '新しいユーザーを作成し、それを返す' do
        result_user = AuthProvider.from_omniauth(google_oauth2)
        expect(result_user).to be_persisted
        expect(result_user.name).to eq(google_oauth2['info']['name'])
        expect(result_user.email).to eq(google_oauth2['info']['email'])
        expect(AuthProvider.exists?(uid: google_oauth2['uid'], provider: google_oauth2['provider'])).to be_truthy
      end
    end

    context 'プロバイダーが存在するがユーザーが存在しない場合' do
      before do
        create(:google_oauth2, uid: google_oauth2['uid'], provider: google_oauth2['provider'])
      end

      it '新しいユーザーを作成し、そのプロバイダーと関連付けること' do
        result_user = AuthProvider.from_omniauth(google_oauth2)
        expect(result_user).to be_persisted
        expect(AuthProvider.find_by(uid: google_oauth2['uid'], provider: google_oauth2['provider']).user).to eq(result_user)
      end
    end
  end

  describe "from_omniauth(:line)" do
    let(:line) { build(:line) } # OmniAuthデータを生成
    let(:existing_user) { create(:user) }

    context 'プロバイダーとユーザーが既に存在する場合' do
      before do
        create(:line, user: existing_user, uid: line['uid'], provider: line['provider'])
      end

      it '既存のユーザーを返すこと' do
        result_user = AuthProvider.from_omniauth(line)
        expect(result_user).to eq(existing_user)
      end
    end

    context 'プロバイダーが存在しない場合' do
      it '新しいユーザーを作成し、それを返す' do
        result_user = AuthProvider.from_omniauth(line)
        expect(result_user).to be_persisted
        expect(result_user.name).to eq(line['info']['name'])
        expect(result_user.email).to eq(line['info']['email'])
        expect(AuthProvider.exists?(uid: line['uid'], provider: line['provider'])).to be_truthy
      end
    end

    context 'プロバイダーが存在するがユーザーが存在しない場合' do
      before do
        create(:line, uid: line['uid'], provider: line['provider'])
      end

      it '新しいユーザーを作成し、そのプロバイダーと関連付けること' do
        result_user = AuthProvider.from_omniauth(line)
        expect(result_user).to be_persisted
        expect(AuthProvider.find_by(uid: line['uid'], provider: line['provider']).user).to eq(result_user)
      end
    end
  end
end

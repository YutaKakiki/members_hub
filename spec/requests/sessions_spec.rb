require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "GET /sessions" do
    let(:user){create(:user,:authenticated)}
    before do
      get new_user_session_path
    end

    context "正しい情報で普通のログインをした時" do
      it "ログインに成功する" do
        post user_session_path,params:{
          user:{
            email:user.email,
            password:user.password
          }
        }
        expect(response).to have_http_status(:see_other)
        expect(response).to redirect_to root_path
      end
    end

    context "不正な情報で普通のログインをした時" do
      it 'ログインに失敗する場合' do
        post user_session_path, params: {
          user: {
            email: 'invalid@example.com',
            password: 'wrongpassword'
          }
        }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /users/sign_out' do
    let(:user){create(:user,:authenticated)}
    it 'ログアウトに成功する' do
      sign_in user

      delete destroy_user_session_path
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)
    end
  end
end

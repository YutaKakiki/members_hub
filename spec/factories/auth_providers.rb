# spec/factories/omniauth_auth_hash.rb
FactoryBot.define do
  factory :google_oauth2, class: OmniAuth::AuthHash do
    # データを動的に生成するためのパラメータを一時定義
    transient do
      provider { 'google_oauth2' }
      uid { '111111111' }
      name { 'Example User' }
      email { 'test@example.com' }
    end
    # データ作成
    initialize_with do
      new({
            'provider' => provider,
            'uid' => uid,
            'info' => {
              'name' => name,
              'email' => email
            }
          })
    end
  end

  factory :line, class: OmniAuth::AuthHash do
    transient do
      provider { 'line' }
      uid { '2222222222' }
      name { 'Example User' }
      email { 'test@example.com' }
    end

    initialize_with do
      new({
            'provider' => provider,
            'uid' => uid,
            'info' => {
              'name' => name,
              'email' => email
            }
          })
    end
  end
end

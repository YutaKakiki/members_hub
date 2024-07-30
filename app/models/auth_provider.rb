class AuthProvider < ApplicationRecord
  belongs_to :user

  def self.from_omniauth(auth)
    uid = auth["uid"]
    provider = auth["provider"]
    email=auth["info"]["email"]
    auth_provider = AuthProvider.find_by(uid: uid, provider: provider)

    # providerが既にあって、ユーザーが登録されていない時（あんまりないと思うけど）
    if auth_provider.present?
      user = User.find_by(id: auth_provider.user_id)
      #ユーザーが見つかったらuserに格納し、なければ作成・保存
      user ||= create_user_via_provider(auth)
    else #providerを持っていないとき
      user = User.find_by(email: email)
      #既に新規登録（普通の）がしてあったら、provider情報のみ保存する
      if user.present?
        # provider情報を保存
        AuthProvider.create({
          uid: uid,
          provider: provider,
          user_id: user.id
        })
      else #全くの新規ユーザーであれば、ユーザー＆プロバイダの両方を保存する
        user = create_user_and_provider(auth)
      end
    end

    user
  end

  private

  def self.create_user_via_provider(auth)
    User.create({
      name: auth["info"]["name"],
      email: auth["info"]["email"],
      password: Devise.friendly_token(10),
      confirmed_at: Time.now
    })
  end

  def self.create_user_and_provider(auth)
    user = create_user_via_provider(auth)
    AuthProvider.create({
      uid: auth["uid"],
      provider: auth["provider"],
      user_id: user.id,
    })
    user
  end
end

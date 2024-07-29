class AuthProvider < ApplicationRecord
  belongs_to :user

  def self.from_omniauth(auth)
    uid = auth.uid
    provider = auth.provider
    auth_provider = AuthProvider.find_by(uid: uid, provider: provider)

    if auth_provider.present?
      user = User.find_by(id: auth_provider.user_id)
      user ||= create_user_via_provider(auth)
    else
      user = User.find_by(email: auth.info.email)
      if user.present?
        # provider情報を保存
        AuthProvider.create({
          uid: uid,
          provider: provider,
          user_id: user.id
        })
      else
        user = create_user_and_provider(auth)
      end
    end

    user
  end

  private

  def self.create_user_via_provider(auth)
    User.create({
      name: auth.info.name,
      email: auth.info.email,
      password: Devise.friendly_token(10),
      confirmed_at: Time.now
    })
  end

  def self.create_user_and_provider(auth)
    user = create_user_via_provider(auth)
    AuthProvider.create({
      uid: auth.uid,
      provider: auth.provider,
      user_id: user.id,
    })
    user
  end
end

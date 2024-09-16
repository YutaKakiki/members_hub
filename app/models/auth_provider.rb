class AuthProvider < ApplicationRecord
  belongs_to :user

  def self.from_omniauth(auth)
    uid = auth['uid']
    provider = auth['provider']
    # lineがemailを参照できない場合を考慮
    email = auth['info']['email'] || ""
    auth_provider = AuthProvider.find_by(uid:, provider:)

    # providerが既にあって、ユーザーが登録されていない時（あんまりないと思うけど）
    if auth_provider.present?
      user = User.find_by(id: auth_provider.user_id)
      # ユーザーが見つかったらuserに格納し、なければ作成・保存
      user ||= create_user_via_provider(auth)
    else # providerを持っていないとき
      user = User.find_by(email:)
      # 既に新規登録（普通の）がしてあったら、provider情報のみ保存する
      if user.present?
        # provider情報を保存
        AuthProvider.create({
                              uid:,
                              provider:,
                              user_id: user.id
                            })
      else # 全くの新規ユーザーであれば、ユーザー＆プロバイダの両方を保存する
        user = create_user_and_provider(auth)
      end
    end

    user
  end

  def self.create_user_via_provider(auth)
    user = User.new({
      name: auth['info']['name'],
      email: auth['info']['email'] ||  "#{Devise.friendly_token(10)}@members-hub.com",
      password: Devise.friendly_token(10),
      confirmed_at: Time.zone.now
    })

    # メールアドレスがない（line）場合、バリデーションを通したくないのでこの場合のみバリデーション回避
    user.save(validate: false)
    user
  end

  def self.create_user_and_provider(auth)
    user = create_user_via_provider(auth)
    AuthProvider.create({
                          uid: auth['uid'],
                          provider: auth['provider'],
                          user_id: user.id
                        })
    user
  end
end

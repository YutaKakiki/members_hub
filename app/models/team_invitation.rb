class TeamInvitation < ApplicationRecord
  belongs_to :team

  def self.generate_or_retrieve_token(team)
    invitation = find_by(team_id: team.id)
    # invitationがあって、有効期限内ならインスタンスを返す
    if invitation && !invitation.expires?
      [invitation, nil]
    else
      token = create_token
      digest = to_digest(token)
      # invitationがDBにあれば、update
      # invitation= というようにインスタンスを改めて格納しようと思ったけど、updateの戻り値は真偽らしい
      invitation.update(invitation_digest: digest, expires_at: 24.hours.from_now) if invitation.present?
      # なかったら、create
      invitation = team.create_team_invitation(invitation_digest: digest, expires_at: 24.hours.from_now) if invitation.blank?
      [invitation, token]
    end
  end

  def expires?
    expires_at < Time.current
  end

  # トークンを生成
  def self.create_token
    SecureRandom.urlsafe_base64
  end

  # インスタンスのトークンをハッシュ化
  def self.to_digest(token)
    BCrypt::Password.create(token)
  end

  def self.authenticated?(team, token)
    return false unless team

    team_invitation = team.team_invitation
    invitation_digest = team_invitation.invitation_digest
    BCrypt::Password.new(invitation_digest).is_password?(token)
  end
end

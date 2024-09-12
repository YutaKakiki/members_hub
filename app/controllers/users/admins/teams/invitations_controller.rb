class Users::Admins::Teams::InvitationsController < ApplicationController
  before_action { AuthenticateAdmin.call(current_user, params[:team_id], self) }

  def show
    @team = Team.find_by(uuid: params[:team_id])
    # トークンを生成しなかった場合はトークンに関してはnilを返す
    # team_invitationインスタンスは必ず返す
    invitation, @token = TeamInvitation.generate_or_retrieve_token(@team)
    if @token.present?
      # クッキーの値は24時間で消える
      cookies[:invitation_token] = { value: @token, expires: 24.hours.from_now }
    else
      # トークンが上のクラスメソッドで返らなかったということは、まだ有効期限中であり、cookieに保存されている
      @token = cookies[:invitation_token]
    end
    @expires_at = invitation.expires_at
  end
end

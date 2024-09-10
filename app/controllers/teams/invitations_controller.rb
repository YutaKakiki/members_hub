class Teams::InvitationsController < ApplicationController
  # HACK: もっとskinnyにすべき

  def show
    team = Team.find_by(uuid: params[:team_id])
    invitation_token = params[:token]
    # トークンは正しい？
    if TeamInvitation.authenticated?(team, invitation_token)
      invitation = team.team_invitation
      # 有効期限が切れている場合は、ルートパスにリダイレクト
      if invitation.expires?
        redirect_to root_path
        flash[:alert] = I18n.t('alert.teams.invitation.expired_link')
        return
      end
      # ログインしていた場合は、認証成功
      if current_user
        # すでにメンバーであれば参加しない
        if Member.member_of_team?(current_user, team)
          redirect_to root_path
          flash[:alert] = I18n.t('alert.members.prevent_dup_member')
          return
        end
        authenticated_successfully_and_join(current_user, team)
      else
        # セッションに格納しておいて、ログイン後/または本人確認(confirtmation#create)の際にこのアクションにリダイレクト
        # もう一度このアクションを行うことで、すべての条件を突破して認証に成功する流れ。
        store_url(invitation_token, team)
        flash[:alert] = I18n.t('alert.teams.invitation.login_or_registration_required')
        redirect_to new_user_session_path
      end
    else
      flash[:alert] = I18n.t('alert.teams.invitation.invalid_link')
      redirect_to root_path
    end
  end

  private

  def authenticated_successfully_and_join(user, team)
    user.members.create(team_id: team.id)
    session[:member_id] = user.members.last.id
    flash[:notice] = I18n.t('notice.teams.invitation.authenticated_and_join_successfully', team: team.name)
    redirect_to new_users_members_profile_value_path(team_id: team.uuid)
  end

  def store_url(token, team)
    session[:invitation_url] = teams_invitation_url(token:, team_id: team.uuid)
  end
end

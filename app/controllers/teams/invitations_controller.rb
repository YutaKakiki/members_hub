class Teams::InvitationsController < ApplicationController
  def show
    team=Team.find_by(uuid:params[:id])
    unless current_user
      # ログイン後にこのアクションに飛ばすため
      session[:forward_url]=teams_invitation_path(team.uuid)
      flash[:alert]="ログイン/新規登録をしてください"
      redirect_to new_user_session_path
      return
    end
    if Member.member_of_team?(current_user,team)
      redirect_to root_path
      flash[:alert]="既に#{team.name}に参加しています"
    else
      # メンバーにする
      current_user.members.create(team_id: team.id)
      # EnsureProfileExistsコールバックオブジェクトにて使用
      # 遷移先で直近で作成したmemberを取得するため
      session[:member_id] = current_user.members.last.id
      redirect_to new_users_members_profile_value_path(team_id: team.uuid)
      flash[:notice] = I18n.t('notice.teams.authentication_succeed', team: team.name)
    end
  end
end

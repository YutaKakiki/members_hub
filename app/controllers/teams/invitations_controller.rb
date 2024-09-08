class Teams::InvitationsController < ApplicationController

  def show
    team=Team.find_by(uuid:params[:team_id])
    invitation_token=params[:token]
    # トークンは正しい？
    if TeamInvitation.authenticated?(team,invitation_token)
      invitation=team.team_invitation
      # 有効期限が切れている場合は、ルートパスにリダイレクト
      if invitation.expires?
        redirect_to root_path
        flash[:alert]="有効期限が切れたURLです"
        return
      end
      # ログインしていた場合は、認証成功
      if current_user
        current_user.members.create(team_id:team.id)
        session[:member_id] = current_user.members.last.id
        flash[:notice]="招待リンクによる #{team.name} への認証に成功しました"
        redirect_to new_users_members_profile_value_path(team_id:team.uuid)
      else
        # セッションに格納しておいて、ログイン後/または本人確認(confirtmation#create)の際にこのアクションにリダイレクト
        # もう一度このアクションを行うことで、すべての条件を突破して認証に成功する流れ。
        session[:invitation_url]= teams_invitation_url(token:invitation_token,team_id:team.uuid)
        flash[:alert]="ログイン/新規登録してください"
        redirect_to new_user_session_path
      end
    else
      flash[:alert]="無効なURLです"
      redirect_to root_path
    end
  end





  # def show
  #   team=Team.find_by(uuid:params[:id])
  #   unless current_user
  #     # ログイン後にこのアクションに飛ばすため
  #     session[:forward_url]=teams_invitation_path(team.uuid)
  #     flash[:alert]="ログイン/新規登録をしてください"
  #     redirect_to new_user_session_path
  #     return
  #   end
  #   if Member.member_of_team?(current_user,team)
  #     redirect_to root_path
  #     flash[:alert]="既に#{team.name}に参加しています"
  #   else
  #     # メンバーにする
  #     current_user.members.create(team_id: team.id)
  #     # EnsureProfileExistsコールバックオブジェクトにて使用
  #     # 遷移先で直近で作成したmemberを取得するため
  #     session[:member_id] = current_user.members.last.id
  #     redirect_to new_users_members_profile_value_path(team_id: team.uuid)
  #     flash[:notice] = I18n.t('notice.teams.authentication_succeed', team: team.name)
  #   end
  # end
end

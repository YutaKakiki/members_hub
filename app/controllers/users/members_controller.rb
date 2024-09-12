class Users::MembersController < ApplicationController
  # メンバーとして登録する画面
  def new
  end

  # メンバーとして登録する
  def create
    if (@team = Team.authenticate_team(params))
      # 既にメンバーとなっていれば、ここで脱出する
      return prevent_dup_member if Member.member_of_team?(current_user, @team)

      Member.join_team(current_user, @team)
      # EnsureProfileExistsコールバックオブジェクトにて使用
      # 遷移先で直近で作成したmemberを取得するため
      session[:member_id] = Member.find_last_joined_team(current_user).id
      # プロフィール登録画面へ遷移させる
      redirect_to new_users_members_profile_value_path(team_id: @team.uuid)
      flash[:notice] = I18n.t('notice.teams.authentication_succeed', team: @team.name)
    else
      flash[:alert] = I18n.t('alert.teams.invalid_team_id/password_combination')
      render :new, status: :unprocessable_entity
    end
  end

  # チームから退会する（メンバーとしての登録を削除）
  def destroy
    member = Member.find_by(id: params[:id])
    team = member.team
    redirect_to users_members_path
    if member.destroy
      flash[:notice] = "#{team.name} を退会しました"
    else
      flash[:alert] = "#{team.name} の退会に失敗しました"
    end
  end

  private

  def prevent_dup_member
    flash.now[:alert] = I18n.t('alert.members.prevent_dup_member')
    render :new, status: :unprocessable_entity
  end
end

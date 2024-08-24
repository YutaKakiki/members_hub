class Users::MembersController < ApplicationController
  # メンバーとして登録する画面
  def new
  end

  # メンバーとして登録する
  def create
    if (@team = Team.authenticate_team(params))
      current_user.members.create(team_id: @team.id)
      # EnsureProfileExistsコールバックオブジェクトにて使用
      # 遷移先で直近で作成したmemberを取得するため
      session[:member_id] = current_user.members.last.id
      # リダイレクト先でteamを参照するため
      session[:team_id] = @team.uuid
      # プロフィール登録画面へ遷移させる
      redirect_to new_users_members_profile_value_path
    else
      flash[:alert] = I18n.t('alerts.teams.invalid_team_id/password_combination')
      render :new, status: :unprocessable_entity
    end
  end

  # チームから退会する（メンバーとしての登録を削除）
  def destroy
  end
end

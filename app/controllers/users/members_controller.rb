class Users::MembersController < ApplicationController
  # メンバーとして登録する画面
  def new
  end

  # メンバーとして登録する
  def create
    if @team=Team.authenticate_team(params)
      current_user.members.create(team_id:@team.id)
      session[:member_id]=current_user.members.last.id
      # リダイレクト先でteamを参照するため
      session[:team_id]=@team.uuid
      # プロフィール登録画面へ遷移させる
      redirect_to new_users_members_profile_path
    else
      flash[:alert]="チームID/パスワードの組み合わせに誤りがあります"
      render :new, status: :unprocessable_entity
    end
  end

  # チームから退会する（メンバーとしての登録を削除）
  def destroy
  end
end

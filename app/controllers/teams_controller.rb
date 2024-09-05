class TeamsController < ApplicationController
  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    # teamにユニークなIDを付与
    @team.uuid = SecureRandom.uuid
    @team.logo.attach(params[:logo]) if params[:logo]
    if @team.save
      Admin.set_as_admin(current_user, @team)
      # EnsureTeamProfileExistsコールバックオブジェクトにて使用
      # 遷移先でチームを参照できるようにするため
      session[:team_id] = @team.id
      redirect_to new_teams_profile_field_path(team_id:@team.uuid)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    team=Team.find_by(id:params[:id])
    if team.destroy
      flash[:notice]=I18n.t("notice.teams.successfully_deleted",team:team.name)
      redirect_to users_admins_teams_path
    else
      flash[:alert]=I18n.t("alert.teams.delete_failed",team:team.name)
      redirect_to users_admins_teams_path
    end
  end

  private

  def team_params
    params.require(:team).permit(:name, :password, :password_confirmation, :logo)
  end
end

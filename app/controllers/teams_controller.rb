class TeamsController < ApplicationController
  before_action -> { AuthenticateAdmin.call(current_user, params[:id], self) }, only: :edit

  def new
    @team = Team.new
  end

  def edit
    @team = Team.find_by(uuid: params[:id])
  end

  def create
    @team = Team.create_team(team_params)
    if @team.save
      Admin.set_as_admin(current_user, @team)
      # EnsureTeamProfileExistsコールバックオブジェクトにて使用
      # 遷移先でチームを参照できるようにするため
      session[:team_id] = @team.id
      redirect_to new_teams_profile_field_path(team_id: @team.uuid)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @team = Team.find_by(id: params[:id])
    return unless @team

    if @team.update(team_params)
      @team.attach_logo(team_params)
      flash[:notice] = I18n.t('notice.teams.updated_successfully')
      redirect_to users_admins_teams_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    team = Team.find_by(id: params[:id])
    if team.destroy
      flash[:notice] = I18n.t('notice.teams.successfully_deleted', team: team.name)
    else
      flash[:alert] = I18n.t('alert.teams.delete_failed', team: team.name)
    end
    redirect_to users_admins_teams_path
  end

  private

  def team_params
    params.require(:team).permit(:name, :password, :password_confirmation, :logo)
  end
end

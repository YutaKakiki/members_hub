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
      redirect_to new_teams_profile_field_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def team_params
    params.require(:team).permit(:name, :password, :password_confirmation, :logo)
  end
end

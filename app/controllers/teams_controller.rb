class TeamsController < ApplicationController
  def index
    @teams = current_user.teams
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    @team.uuid = SecureRandom.uuid
    @team.logo.attach(params[:logo]) if params[:logo]
    if @team.save
      # teamにユニークなIDを付与
      Admin.set_as_admin(current_user, @team)
      redirect_to teams_path
      flash[:notice] = "新しくチーム #{@team.name} が作成されました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def team_params
    params.require(:team).permit(:name, :password, :password_confirmation, :logo)
  end
end

class Teams::MembersController < ApplicationController
  def index
    @team=Team.find_by(uuid:params[:team_id])
    @members=@team.members if @team
  end
end

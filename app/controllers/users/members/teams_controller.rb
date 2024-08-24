class Users::Members::TeamsController < ApplicationController
  def index
    @teams = current_user.teams
  end
end

class Users::Admins::TeamsController < ApplicationController
  # 管理しているチームを閲覧
  def index
    @admin_teams = current_user.admin_teams
  end
end

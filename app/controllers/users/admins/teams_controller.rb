class Users::Admins::TeamsController < ApplicationController
  before_action :notify_team_completion
  def index
    @teams = current_user.admin_teams.includes(logo_attachment: :blob)
  end

  private

  # チームの登録が完了したら、Users::Admins::TeamsController#indexにリダイレクトする
  # チームが正常に作成されたことを知らせるため
  def notify_team_completion
    team_created_now = Team.find_by(id: session[:team_id])
    return false unless team_created_now

    return unless team_created_now.name == current_user.admin_teams.last.name

    flash[:notice] = "#{team_created_now.name} がチームとして正常に作成されました"
    # チームを参照することはなく、情報を維持する必要がないため、sessionを空にする
    session[:team_id] = nil
  end
end

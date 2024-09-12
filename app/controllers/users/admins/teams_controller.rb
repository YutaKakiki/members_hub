class Users::Admins::TeamsController < ApplicationController
  before_action :notify_team_completion, :notify_profile_field_updated

  def index
    @teams = Team.admin_teams(current_user)
  end

  private

  # チームの登録が完了したら、Users::Admins::TeamsController#indexにリダイレクトする
  # チームが正常に作成されたことを知らせるため
  def notify_team_completion
    team_created_now = Team.find_by(id: session[:team_id])

    return false unless team_created_now
    return unless  Team.this_is_created_team_now?(current_user, team_created_now)

    flash[:notice] = "#{team_created_now.name} がチームとして正常に作成されました"
    # チームを参照することはなく、情報を維持する必要がないため、sessionを空にする
    session[:team_id] = nil
  end

  # 上と同じく、項目の編集が完了すれば、indexアクションにリダイレクトする
  # チームの新規作成時を除いて、更新があった場合はフラッシュを出す。
  def notify_profile_field_updated
    return if session[:team_id] # チーム新規作成時は脱出
    return unless session[:team_of_profile_field_updated_now] # 更新していなかった場合も脱出

    updated_team = Team.find_by(uuid: session[:team_of_profile_field_updated_now])
    return unless updated_team # セッションに入っていたIDのチームが見つからなかった時も脱出（チームを消した時とかに発生）

    flash[:notice] = I18n.t('notice.profile_fields.update_successfully', team: updated_team.name)
    session[:team_of_profile_field_updated_now] = nil
  end
end

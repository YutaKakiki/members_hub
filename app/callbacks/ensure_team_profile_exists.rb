class EnsureTeamProfileExists
  def initialize(session,controller)
    @controller=controller
    @session = session
  end

  def callback
    team=Team.find_by(id:@session)
    if team
      unless team.is_team_has_profile_values_more_than_3
        team.destroy
        @controller.flash[:alert]="プロフィールを追加登録しなかったため、チームの作成を取消しました"
      end
    end
  end
end

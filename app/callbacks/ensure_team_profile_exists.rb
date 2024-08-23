class EnsureTeamProfileExists
  def initialize(session,controller)
    @controller=controller
    @session = session
  end

  def callback
    team=Team.find_by(id:@session)
    if team
      unless is_team_has_profile_values_more_than_3(team)
        team.destroy
        @controller.flash[:alert]="プロフィールを追加登録しなかったため、チームの作成を中断しました"
      end
    end
  end


  # デフォルトで追加する２項目に加えて追加項目を登録しているかどうか
  # 追加登録しなかった→チームの作成を中断したとみなす
  def is_team_has_profile_values_more_than_3(team)
    team.profile_fields.count >= 3
  end
end

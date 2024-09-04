module TeamsHelper
  def current_member(team)
    Member.where(team_id:team.id,user_id:current_user.id).first
  end
end

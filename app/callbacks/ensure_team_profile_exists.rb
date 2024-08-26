class EnsureTeamProfileExists
  def initialize(session, controller)
    @controller = controller
    @session = session
  end

  def callback
    team = Team.find_by(id: @session)
    return unless team
    return if team.team_has_profile_values_more_than_three?

    team.destroy
    @controller.flash[:alert] = I18n.t('alert.callbacks.team_has_profile_fields_less_than_two')
  end
end

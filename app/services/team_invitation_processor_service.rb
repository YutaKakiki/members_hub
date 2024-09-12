class TeamInvitationProcessorService
  def self.call(team, token, current_user)
    new(team, token, current_user).call
  end

  def initialize(team, token, current_user)
    @team = team
    @token = token
    @current_user = current_user
  end

  def call
    return :expired_token if token_expires?(@team)
    return :invalid_token unless TeamInvitation.authenticated?(@team, @token)

    return :login_or_registration_required unless @current_user
    return :already_joined if Member.member_of_team?(@current_user, @team)

    Member.join_team(@current_user, @team)
    :join_team_successfully
  end

  def token_expires?(team)
    return false unless team

    team.team_invitation.expires?
  end
end

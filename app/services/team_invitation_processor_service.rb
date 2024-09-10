class TeamInvitationProcessorService

  def self.call(team,token,current_user)
    self.new(team,token,current_user).call
  end

  def initialize(team,token,current_user)
    @team = team
    @token=token
    @current_user=current_user
  end

  def call
    return :expired_token if token_expires?(@team)
    return :invalid_token unless TeamInvitation.authenticated?(@team,@token)
    if @current_user
      return :already_joined if Member.member_of_team?(@current_user,@team)
      Member.joined_team(@current_user, @team)
      return :join_team_successfully
    else
      return :login_or_registration_required
    end
  end

  private

    def token_expires?(team)
      team.team_invitation.expires?
    end

end

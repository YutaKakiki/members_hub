class AuthenticateAdmin
  def self.call(user, team_id, controller)
    new(user, team_id, controller).call
  end

  def initialize(user, team_id, controller)
    @user = user
    @team_id = team_id
    @controller = controller
  end

  def call
    puts @team_id
    team = Team.find_by(uuid: @team_id)
    return if Admin.authenticate?(@user, team)

    @controller.flash[:alert] = I18n.t('alert.admin.require_admin_role')
    @controller.redirect_to @controller.root_path
  end
end

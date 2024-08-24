class EnsureMemberProfileExists
  # before_actionで使い、ApplicationControllerに置く
  # profileが登録されていないmemberの登録は削除される
  # memberとprofileの作成は、トランザクションとして管理する

  def initialize(session, controller)
    @controller = controller
    @session = session
  end

  def callback
    member = Member.find_by(id: @session)
    return unless member
    return if member_has_profile_values?(member)

    member.destroy
    @controller.flash[:alert] = I18n.t('alerts.callbacks.members_without_profile')
  end

  def member_has_profile_values?(member)
    member.profile_values.present?
  end
end

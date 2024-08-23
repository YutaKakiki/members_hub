class EnsureMemberProfileExists
  # before_actionで使い、ApplicationControllerに置く
  # profileが登録されていないmemberの登録は削除される
  # memberとprofileの作成は、トランザクションとして管理する

  def initialize(session,controller)
    @controller=controller
    @session = session
  end

  def callback
    member=Member.find_by(id:@session)
    if member
      unless is_member_has_profile_values(member)
        member.destroy
        @controller.flash[:alert]="プロフィールを記入しなかったため、チームへの参加を中断しました"
      end
    end
  end

  def is_member_has_profile_values(member)
    member.profile_values.present?
  end
end

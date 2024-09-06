module Users::AdminsHelper
  # ログインしているユーザーがそのチームのAdminユーザーか判断
  def are_you_admin_user?(team,user)
    team.admin_user == user
  end

  def not_admin_member?(team,member)
    user=member.user
    team.admin_user != user
  end

end

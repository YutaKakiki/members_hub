module FormHelper
  # フォームを共通化
  def form_path_for(content, _resource)
    content == :registration ? user_registration_path : user_session_path
  end
end

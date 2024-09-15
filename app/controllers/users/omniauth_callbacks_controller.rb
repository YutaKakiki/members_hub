# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  protect_from_forgery
  skip_before_action: :authenticate_user!
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/heartcombo/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end

  def google_oauth2
    callback_for(:google)
  end

  def line
    callback_for(:line)
  end

  private

    def callback_for(provider)
      auth = request.env['omniauth.auth']
      @user = AuthProvider.from_omniauth(auth)
      if @user.persisted?
        # チーム招待リンクをリクエストした後のOAuthならば、チーム認証の挙動にリダイレクト
        if (invitation_url = session[:invitation_url])
          sign_in @user
          session[:invitation_url] = nil
          redirect_to invitation_url
        else
          sign_in_and_redirect @user, event: :authentication
          set_flash_message(:notice, :success, kind: provider.to_s.capitalize) if is_navigational_format?
        end
      else
        flash[:alert] = I18n.t('omniauth_callbacks.failure')
        render template: 'devise/registrations/new'
      end
    end
end

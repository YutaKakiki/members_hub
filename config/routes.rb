Rails.application.routes.draw do
  get 'home/index'
  root to:"home#index"
  # カスタムコントローラに変更
  devise_for :users, controllers: {
    confirmations: "users/confirmations",
    sessions: 'users/sessions',
    registrations: "users/registrations",
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  resources :teams
  namespace :users do
    resources :admin_teams,only: :index
  end
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end

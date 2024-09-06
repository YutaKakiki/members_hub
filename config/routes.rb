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

  namespace :teams do
    resources :profile_fields
  end
  resources :teams do
    resources :filters, only: %i[create index],controller:"teams/members/filters",as: :members_filters
    resources :members, only: %i[index show], module: :teams
  end
  resources :users,only: %i[edit destroy]
  namespace :users do
    resource :admin,only: :update
    namespace :admins do
      resources :teams,only: :index
    end
    namespace :members do
      resources :teams,only: :index
      resources :profile_values
    end
    resources :members
  end
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end

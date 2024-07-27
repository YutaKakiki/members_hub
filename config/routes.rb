Rails.application.routes.draw do
  get 'home/index'
  root to:"home#index"
  # カスタムコントローラに変更
  devise_for :users, controllers: {
    confirmations: "users/confirmations",
    sessions: 'users/sessions',
    registrations: "users/registrations",
  }
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end

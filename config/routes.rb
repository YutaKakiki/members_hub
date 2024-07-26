Rails.application.routes.draw do
  get 'home/index'
  root to:"home#index"
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: "users/registrations",
  }
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end

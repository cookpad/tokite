Tokite::Engine.routes.draw do
  root to: "top#show"

  resources :hooks, only: %w(create)
  resources :users, only: %w(index show create edit update destroy) do
    resources :rules, only: %w(new create edit update destroy), shallow: true do
      resource :transfers, only: %w(new create)
    end
  end
  resources :rules, only: %w(index)
  resources :watchings, only: %w(index new create destroy)

  get "sign_in", to: "sessions#new", as: "sign_in"
  get "auth/github/callback", to: "sessions#create"
  delete "sign_out", to: "sessions#destroy", as: "sign_out"

  get "site/sha", to: "sha#show"
end

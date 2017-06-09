Rails.application.routes.draw do
  root to: "top#show"

  resources :hooks, only: %w(create)
  resources :users, only: %w(index edit update) do
    resources :rules, only: %w(index new create edit update destroy)
  end
  resources :rules, only: %w(index)

  get "sign_in", to: "sessions#new", as: "sign_in"
  get "auth/google_oauth2/callback", to: "sessions#create"
  delete "sign_out", to: "sessions#destroy", as: "sign_out"

  get "site/sha", to: "sha#show"
end

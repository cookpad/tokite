Rails.application.routes.draw do
  root to: "top#show"

  resources :hooks, only: %w(create)
  resources :users, only: %w(index) do
    resources :rules, only: %w(index)
  end

  get "sign_in", to: "sessions#new", as: "sign_in"
  get "auth/google_oauth2/callback", to: "sessions#create"
  delete "sign_out", to: "sessions#destroy", as: "sign_out"
end

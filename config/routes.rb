Rails.application.routes.draw do
  root to: "top#show"

  resources :hooks, only: %w(create)
end

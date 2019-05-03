Rails.application.routes.draw do
  resources :users, only: [:create, :index, :show]
  resources :accounts, only: [:create, :show]
end

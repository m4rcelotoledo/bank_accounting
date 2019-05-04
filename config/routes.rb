Rails.application.routes.draw do
  resources :users, only: %i[create index show]
  resources :accounts, only: %i[create show]
end

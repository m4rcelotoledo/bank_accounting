# frozen_string_literal: true

Rails.application.routes.draw do
  # Auth routes
  post '/auth/login', to: 'auth#login'
  post '/auth/logout', to: 'auth#logout'
  get '/auth/me', to: 'auth#me'

  resources :users, only: %i[create index show]

  resources :accounts, only: %i[create show]
  get '/balance', to: 'accounts#balance'
  get '/statement', to: 'accounts#statement'

  resources :transactions, only: %i[show]
  post '/deposit', to: 'transactions#deposit'
  post '/transfer', to: 'transactions#transfer'
end

# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users, only: %i[create index show]

  resources :accounts, only: %i[create show]
  get '/balance', to: 'accounts#balance'
  get '/statement', to: 'accounts#statement'

  resources :transactions, only: %i[show]
  post '/deposit', to: 'transactions#deposit'
  post '/transfer', to: 'transactions#transfer'
end

Rails.application.routes.draw do
  resources :users, only: %i[create index show] do
    resources :accounts, only: %i[create show] do
      get '/balance', to: 'accounts#balance'
      resources :transactions, only: %i[create show]
    end
  end
end

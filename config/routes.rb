Rails.application.routes.draw do
  resources :users, only: %i[create index show] do
    resources :accounts, only: %i[create show] do
      resources :transactions, only: %i[create show]
    end
  end

  get '/balance', to: 'accounts#balance'
  post '/transfer', to: 'transactions#transfer'
end

namespace :api, defaults: { format: 'json' } do
  namespace :v1 do
    resources :users, only: %I[create update]

    resources :accounts, only: %I[index create show] do
      scope module: :accounts do
        resources :deposits, only:  :create
        resources :withdraws, only: :create
      end
    end
    
    post 'login', to: 'sessions#create', as: 'login'
  end
end

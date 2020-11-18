Rails.application.routes.draw do

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users do
    resources :schedule_items, only: [:create, :destroy, :update]
    member do
      get '/schedule_items/new', to: 'schedule_items#new'
    end
  end

end

Rails.application.routes.draw do

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/login/line_user', to: 'sessions#line_new'
  post '/login/line_user', to: 'sessions#line_user'

  post '/api/onetime_session', to:'api#onetime_session'

  resources :users do
    resources :schedule_items, only: [:create, :destroy, :update]
    member do
      get '/schedule_items/new', to: 'schedule_items#new'
      get '/schedule_items/:item_id/edit', to: 'schedule_items#edit'
    end
  end

end

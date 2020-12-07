Rails.application.routes.draw do

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/login/line_user', to: 'sessions#line_new'
  post '/login/line_user', to: 'sessions#line_user'

  post '/api/onetime_session', to:'api#onetime_session'

  get '/users/new_admin', to: 'users#new_admin'
  post '/users/create_admin', to: 'users#create_admin'

  resources :users, only: [:index] do
    resources :schedule_items, only: [:create, :destroy, :update]
    member do
      get '/line', to: 'users#show_line'
      delete '/line', to: 'users#destroy_line'
      delete '/admin', to: 'users#destroy_admin'
      get '/edit_admin', to: 'users#edit_admin'
      get '/edit_line', to: 'users#edit_line'
      patch '/edit_admin', to: 'users#update_admin'
      patch '/edit_line', to: 'users#update_line'
      get '/schedule_items/new', to: 'schedule_items#new'
      get '/schedule_items/:item_id/edit', to: 'schedule_items#edit'
    end
  end

end

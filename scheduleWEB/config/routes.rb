Rails.application.routes.draw do

  resources :users do
    resources :schedule_items, only: [:create, :destroy, :update]
    member do
      get '/schedule_items/new', to: 'schedule_items#new'
    end
  end

end

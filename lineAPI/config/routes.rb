Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  post 'receive', to: 'receive#create'
  post 'send_line/messages', to: 'send_line#messages'

end


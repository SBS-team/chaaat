Chat::Application.routes.draw do
  root "message#index"
  get "message/index", to: "message#index"
  post "message/new", to: "message#new",as: "new_message"
  resources :rooms
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  post 'pusher/auth'

end

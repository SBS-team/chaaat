Chat::Application.routes.draw do
  root "message#index"
  resources :users,:path => :persons, :only => [:index, :show]
  resources :friendships, :only => [:create, :destroy]
  get "message/index", to: "message#index"
  get "message/:id", to: "message#show"
  post "message/new", to: "message#new",as: "new_message"
  post "message/search", to: "message#search"
  get "message/search/:search", to: "message#search"
  resources :rooms
  resources :rooms_users, :only => [:create, :destroy]
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  post 'pusher/auth'
end

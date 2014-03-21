Chat::Application.routes.draw do
  root "message#index"
  resources :friendships, :only => [:create, :destroy]
  resources :users,:path => :persons, :only => [:index, :show]
  resources :friendships, :only => [:create, :destroy]

  get "message/index", to: "message#index"
  resources :rooms, :only => [:new, :create, :show]
  resources :rooms_users, :only => [:create, :destroy]
  get "message/:id", to: "message#show"
  post "message/new", to: "message#new",as: "new_message"
  post "message/search", to: "message#search"
  get "message/search/:search", to: "message#search"
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  match "rooms_users/:id/:room_id", :to => "rooms_users#destroy" , :as => "delete_user", :via => :delete
  post 'pusher/auth'
end

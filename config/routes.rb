Chat::Application.routes.draw do


  #root "message#index"

  get "message/index", to: "message#index"
  resources :friendships, :only => [:create, :destroy]
  resources :users,:path => :persons, :only => [:index, :show]
  resources :friendships, :only => [:create, :destroy]

  get "message/:id", to: "message#show"
  post "message/new", to: "message#new",as: "new_message"
  post "message/search", to: "message#search"
  post "users/search", to: "users#search"
  get "users/search/:id", to: "users#search"
  get "message/search/:search", to: "message#search"
  resources :rooms, :only => [:new, :create, :show, :index]
  resources :rooms_users, :only => [:create, :destroy]

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  post 'pusher/auth'


  devise_scope :user do
    root to: "devise/registrations#new"
  end
  match "rooms_users/:id/:room_id", :to => "rooms_users#destroy" , :as => "delete_user", :via => :delete

end

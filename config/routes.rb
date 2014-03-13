Chat::Application.routes.draw do
  root "message#index"
  resources :users,:path => :persons, :only => [:index, :show]
  resources :friendships, :only => [:create, :destroy]
  get "message/index", to: "message#index"
  post "message/new", to: "message#new",as: "new_message"
  resources :rooms
  resources :rooms_users, :only => [:create, :destroy]
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

end

Chat::Application.routes.draw do
  root "message#index"
  resources :users, :path => :persons, :as => "users", :only => [:index, :show]
  resources :friendships, :only => [:create, :destroy]
  resources :users,:path => :persons, :only => [:index, :show]
  resources :friendships, :only => [:create, :destroy]

  get "message/index", to: "message#index"
  post "message/new", to: "message#new", as: "new_message"
  resources :rooms, :only => [:new, :create, :show]
  resources :rooms_users, :only => [:create, :destroy, :search]
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
end

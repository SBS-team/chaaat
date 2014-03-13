Chat::Application.routes.draw do
  devise_for :users

  root :to => "users#index"
  resources :users, :path => :user_actions, :only => [:index, :show]
  resources :friendships, :only => [:create, :destroy]
end

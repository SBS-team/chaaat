Chat::Application.routes.draw do

  root "message#show"
  get "message/index", to: "message#index"
  get "message/:id", to: "message#show"
  post "message/new", to: "message#new", as: "new_message"
  post "message/search", to: "message#search"
  get "message/search/:search", to: "message#search"
  resources :rooms
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

end

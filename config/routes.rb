Chat::Application.routes.draw do
  get "message/index", to: "message#index"
  get "message/:id", to: "message#show"
  post "message/new", to: "message#new",as: "new_message"
  post "message/search", to: "message#search"
  post "users/search", to: "users#search"
  get "users/search/:id", to: "users#search"
  get "message/search/:search", to: "message#search"
  resources :rooms
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  post 'pusher/auth'
  devise_scope :user do
    root to: "devise/registrations#new"
  end
end

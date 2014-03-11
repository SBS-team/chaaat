Chat::Application.routes.draw do
  devise_for :users
  root "message#index"
  get "message/index", to: "message#index"
  post "message/new", to: "message#new",as: "new_message"
  resources :rooms
end

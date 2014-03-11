Chat::Application.routes.draw do
  devise_for :users
  resources :rooms
end

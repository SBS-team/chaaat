Chat::Application.routes.draw do
  resources :rooms
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

end

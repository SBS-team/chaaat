Chat::Application.routes.draw do
<<<<<<< HEAD
=======
  devise_for :users
  root "message#index"
  get "message/index", to: "message#index"
  post "message/new", to: "message#new",as: "new_message"
>>>>>>> 42e8f611161dc3482f62c5dee33a95dbdefae416
  resources :rooms
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

end

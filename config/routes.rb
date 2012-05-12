Pickingwords::Application.routes.draw do
  resources :tracked_words, :except => [:edit, :update]

  authenticated :user do
    root :to => 'home#index'
  end

  root :to => "home#index"

  devise_for :users
  resources :users, :only => [:show, :index]
end

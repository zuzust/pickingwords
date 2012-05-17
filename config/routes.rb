Pickingwords::Application.routes.draw do
  match 'translate' => 'translation#translate', :via => :get

  resources :picked_words, :except => [:new]
  resources :tracked_words, :only => [:index, :show, :destroy]

  authenticated :user do
    root :to => 'home#index'
  end

  root :to => "home#index"

  devise_for :users
  resources :users, :only => [:show, :index]
end

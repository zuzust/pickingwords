Pickingwords::Application.routes.draw do
  post 'translate' => 'translation#translate'

  resources :tracked_words, :only => [:index, :show, :destroy]
  resources :users, :only => [:show, :index] do
    resources :picked_words, :except => [:new]
  end

  devise_for :users

  root :to => 'home#index'
end

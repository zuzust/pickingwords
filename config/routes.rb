Pickingwords::Application.routes.draw do
  get "static_pages/home"
  get "static_pages/help"
  post 'translate' => 'translation#translate'

  resources :tracked_words, :only => [:index, :show, :destroy]

  root :to => 'home#index'

  devise_for :users
  resources :users, :only => [:show, :index] do
    resources :picked_words, :except => [:new]
  end
end

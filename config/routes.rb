Pickingwords::Application.routes.draw do
  get "static_pages/home"
  get "static_pages/help"
  get "static_pages/about"
  get "static_pages/contact"
  post 'translate' => 'translation#translate'

  resources :tracked_words, :only => [:index, :show, :destroy]

  root :to => 'static_pages#home'

  devise_for :users
  resources :users, :only => [:show, :index] do
    resources :picked_words, :except => [:new]
  end
end

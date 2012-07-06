Pickingwords::Application.routes.draw do
  get 'playground' => 'static_pages#playground'
  get 'help'       => 'static_pages#help'
  get 'about'      => 'static_pages#about'
  get 'contact'    => 'static_pages#contact'

  post 'translate' => 'translation#translate'

  resources :tracked_words, :only => [:index, :show, :destroy]

  authenticated :user do
    root :to => 'picked_words#index'
  end

  root :to => 'static_pages#home'

  devise_for :users
  resources :users, :only => [:show, :index] do
    resources :picked_words, :except => [:new]
  end
end

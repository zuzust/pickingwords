Pickingwords::Application.routes.draw do
  controller :static_pages do
    get 'playground' => :playground
    get 'help'       => :help
    get 'about'      => :about
    get 'contact'    => :contact
  end

  resources :tracked_words, :only => [:index, :destroy]

  authenticated :admin do
    root :to => 'tracked_words#index'
  end

  authenticated :user do
    root :to => 'picked_words#index'
  end

  root :to => 'static_pages#home'

  devise_for :admins
  devise_for :users

  resources :users, :only => [:index, :show] do
    resources :picked_words, :except => [:new] do
      get 'search', on: :collection
    end
    get 'translate' => 'translation#translate'
  end
end

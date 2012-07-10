Pickingwords::Application.routes.draw do
  get 'playground' => 'static_pages#playground'
  get 'help'       => 'static_pages#help'
  get 'about'      => 'static_pages#about'
  get 'contact'    => 'static_pages#contact'

  post 'translate' => 'translation#translate'

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
    get 'picked_words/:letter' => 'picked_words#index', letter: /[a-z]{1}/, on: :member, as: :picks_by_letter_of
    resources :picked_words, :except => [:new]
  end
end

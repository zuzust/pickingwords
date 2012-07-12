Pickingwords::Application.routes.draw do
  controller :static_pages do
    get 'playground' => :playground
    get 'help'       => :help
    get 'about'      => :about
    get 'contact'    => :contact
  end

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
    controller :picked_words do
      get 'picked_words/:letter' => :index, letter: /[@a-z]{1}/, on: :member, as: :picks_by_letter_of
      get 'picked_words/:locale' => :index, locale: /[a-z]{2}/, on: :member, as: :picks_by_locale_of
    end
    resources :picked_words, :except => [:new]
  end
end

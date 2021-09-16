Rails.application.routes.draw do
  devise_for :users
  #get 'home/index'
  get 'home/about'
  #root 'home#index'
  root 'products#index'




  resources :users do
  resources :profiles
  end
  resources :accountinfo
  resources :products do
    resources :comments
  end

  resources :relationships
  get 'preferences', to: 'products#preferences'
  get 'profiles', to: 'pages#profiles'
  get 'following', to: 'pages#following'
  get 'search', to: 'products#search'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

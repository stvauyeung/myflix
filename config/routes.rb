Myflix::Application.routes.draw do
  root to: 'static#front'
  get '/home', to: 'videos#index'
  get 'ui(/:action)', controller: 'ui'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  
  get '/register', to: 'users#new'
  resources :users, :only => [:create, :show]
  resources :queuings, :only => [:create, :index, :destroy]
  resources :followings, :only => [:create, :index, :destroy]
  
  put :update_multiple, to: "queuings#update_multiple"

  resources :videos, :only => [:show] do
    resources :reviews, :only => [:create]
    collection { post :search, to: "videos#search" }
  end
  
  resources :categories, :only => [:show]
  
  get '/forgot_password', to: 'forgot_passwords#new'
  get '/forgot_password_confirmation', to: 'forgot_passwords#confirm'
  resources :forgot_passwords, :only => [:create]

  resources :password_resets, :only => [:show, :create]
  get 'expired_token', to: 'password_resets#expired_token'
end

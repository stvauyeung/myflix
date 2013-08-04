Myflix::Application.routes.draw do
  root to: 'static#front'
  get '/home', to: 'videos#index'
  get 'ui(/:action)', controller: 'ui'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  
  get '/register', to: 'users#new'
  get '/register/:token', to: 'users#new_with_invitation_token', as: 'register_with_token'
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
  get 'expired_link', to: 'static#expired_link'

  get 'invitations', to: 'invitations#new'
  resources :invitations, :only => [:create]
end

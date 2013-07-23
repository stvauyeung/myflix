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
  put :update_multiple, to: "queuings#update_multiple"

  resources :videos, :only => [:show] do
    resources :reviews, :only => [:create]
    collection { post :search, to: "videos#search" }
  end
  
  resources :categories, :only => [:show]
end

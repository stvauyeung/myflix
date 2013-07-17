Myflix::Application.routes.draw do
  root to: 'static#front'
  get '/home', to: 'videos#index'
  get 'ui(/:action)', controller: 'ui'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  
  get '/register', to: 'users#new'
  resources :users, :only => [:create]
  resources :queuings, :only => [:create, :index, :destroy]

  resources :videos, :only => [:show] do
    resources :reviews, :only => [:create]
    collection do
      post :search, to: "videos#search"
    end
  end
  
  resources :categories, :only => [:show]
end

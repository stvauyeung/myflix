Myflix::Application.routes.draw do
  get '/', to: 'static#front'
  get '/home', to: 'videos#index'
  get 'ui(/:action)', controller: 'ui'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  
  get '/register', to: 'users#new'
  resources :users, :only => [:create]

  resources :videos, :only => [:show] do
    resources :reviews, :only => [:new, :create]
    collection do
      post :search, to: "videos#search"
    end
  end
  
  resources :categories, :only => [:show]
end

Rails.application.routes.draw do
  root 'static_pages#top'
  get '/signup'=>'users#new'
  
  get "/login"=>"sessions#new"
  post "/login"=>"sessions#create"
  delete "/logout"=>"sessions#destroy"
  
  resources :users do
    member do
      get 'edit_basic_info'
      patch 'update_basic_info'
    end
    resources :attendances, only: :update
  end
end
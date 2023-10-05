Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
   
  namespace :api do
    namespace :v1 do 
      resources :users, only: [:create, :show]
      resources :questions 
      # resources :authenticate
      post '/auth/login', to: 'authentication#login'
      post '/questions/import', to: 'questions#import'
    end
  end
end

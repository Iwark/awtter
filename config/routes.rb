Rails.application.routes.draw do

  get '/health' => 'application#health'
  
  root 'groups#index'

  resources :accounts
  resources :groups

  resources :histories, only:[:index]
  resources :retweets
  resources :tweets
  resources :targets

end

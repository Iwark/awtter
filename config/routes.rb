Rails.application.routes.draw do

  get '/health' => 'application#health'
  
  root 'groups#index'

  get 'accounts/:id/follow_follower'

  resources :accounts
  resources :groups

  resources :histories, only:[:index]
  resources :retweets
  resources :tweets
  resources :targets

end

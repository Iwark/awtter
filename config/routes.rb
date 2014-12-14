Rails.application.routes.draw do

  get '/health' => 'application#health'
  
  root 'groups#index'

  post 'accounts/:id/follow_follower' => 'accounts#follow_follower'

  resources :accounts
  resources :groups

  resources :histories, only:[:index]
  resources :retweets
  resources :tweets
  resources :targets

end

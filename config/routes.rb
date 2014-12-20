Rails.application.routes.draw do

  get '/health' => 'application#health'
  
  root 'groups#index'

  get 'accounts/:id/follow_follower' => 'accounts#follow_follower'
  post 'histories/clear'

  resources :accounts
  resources :groups

  resources :histories, only:[:index]
  resources :retweets
  resources :tweets
  resources :targets

end

Rails.application.routes.draw do
  root 'groups#index'

  resources :accounts
  resources :groups

  resources :histories, only:[:index]
  resources :retweets, only:[:index]

end

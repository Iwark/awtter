Rails.application.routes.draw do
  root 'groups#index'

  resources :accounts
  resources :groups

end

Rails.application.routes.draw do
  
  root 'tweet#index'
  get 'tweets/index'
  devise_for :users
  resources :tweets
  resources :users, :only => [:show]
  
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end

Rails.application.routes.draw do
  
  root 'tweets#index'
  get 'tweets/index'
  devise_for :users
  #resources :tweets
  resources :users, :only => [:show]
  
  resources :tweets do
    collection do
      match 'search' => 'tweets#search', via: [:get, :post], as: :search
    end
  end
  
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end

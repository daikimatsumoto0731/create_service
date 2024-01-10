Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'user_sessions',
  }

  resources :users, only: [:show]

  root 'static_pages#top'
  
  get 'terms', to: 'static_pages#terms', as: :terms
  get 'privacy_policy', to: 'static_pages#privacy_policy', as: :privacy_policy
end

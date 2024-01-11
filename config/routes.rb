Rails.application.routes.draw do
  get 'vegetables/index'
  devise_for :users, controllers: {
    sessions: 'user_sessions',
  }

  resources :users, only: [:show]

  root 'static_pages#top'
  
  get 'terms', to: 'static_pages#terms', as: :terms
  get 'privacy_policy', to: 'static_pages#privacy_policy', as: :privacy_policy
  # 野菜選択画面へのルーティング
  get 'vegetables', to: 'vegetables#index'
end

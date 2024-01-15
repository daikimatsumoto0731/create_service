Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'user_sessions',
  }

  resources :users, only: [:show]

  root 'static_pages#top'
  
  get 'terms', to: 'static_pages#terms', as: :terms
  get 'privacy_policy', to: 'static_pages#privacy_policy', as: :privacy_policy

  # 野菜選択画面へのルーティング
  get 'vegetables', to: 'vegetables#index'

  # スケジュール画面へのルーティング
  post 'schedule', to: 'vegetables#schedule', as: :schedule

  # /schedule パスの場合、custom_schedule アクションを呼び出す
  get 'custom_schedule', to: 'vegetables#custom_schedule', as: 'custom_schedule'
end

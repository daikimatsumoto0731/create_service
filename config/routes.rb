Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'user_sessions',
    passwords: 'users/passwords',
    omniauth_callbacks: "omniauth_callbacks"
  }

  resources :users, only: [:show]

  root 'static_pages#top'
  
  get 'terms', to: 'static_pages#terms', as: :terms
  get 'privacy_policy', to: 'static_pages#privacy_policy', as: :privacy_policy

  # LINE通知設定へのルーティング
  get 'line_notification_settings', to: 'line_notifications#edit', as: 'line_notification_settings'
  patch 'line_notification_settings', to: 'line_notifications#update'
  post 'notify_callback', to: 'line_notifications#notify_callback'

  # スケジュール画面へのルーティング
  get 'custom_schedule', to: 'vegetables#custom_schedule', as: 'custom_schedule'

  # 選択ボタンを押した先のルーティング
  post 'schedule', to: 'vegetables#schedule'

  # 野菜選択画面へのルーティング
  get 'vegetables', to: 'vegetables#index', as: :vegetables
end
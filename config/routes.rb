Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'user_sessions',
    passwords: 'users/passwords'
  }

  resources :users, only: [:show]

  root 'static_pages#top'
  
  get 'terms', to: 'static_pages#terms', as: :terms
  get 'privacy_policy', to: 'static_pages#privacy_policy', as: :privacy_policy

  # LINE通知設定へのルーティング
  get 'line_notification_settings', to: 'static_pages#line_notification_settings', as: 'line_notification_settings'
  patch 'line_notification_settings', to: 'static_pages#line_notification_settings'

  # スケジュール画面へのルーティング
  get 'custom_schedule', to: 'schedule#custom_schedule', as: 'custom_schedule'

  # 選択ボタンを押した先のルーティング
  post 'schedule', to: 'vegetables#schedule'

  # 野菜選択画面へのルーティング
  get 'vegetables', to: 'vegetables#index', as: :vegetables

  # アドバイスアクションへのルーティング
  get 'planting_advice', to: 'schedule#planting_advice'
  get 'thinning_advice', to: 'schedule#thinning_advice'
end
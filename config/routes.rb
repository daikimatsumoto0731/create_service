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

  # 野菜選択画面へのルーティング
  get 'vegetables', to: 'vegetables#index', as: :vegetables
  
  # 野菜選択後のスケジュール表示アクションへのルーティング
  get 'vegetables/schedule', to: 'vegetables#schedule', as: :vegetable_schedule

  # 収穫アクションへのルーティング
  get 'events/harvest', to: 'events#harvest', as: :harvest

  # Eventsに関するルーティング
  resources :events, only: [:index, :show] do
    member do
      get 'advice'
    end
  end
end  
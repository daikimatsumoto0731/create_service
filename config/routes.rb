# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'user_sessions',
    passwords: 'users/passwords',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  resources :users, only: %i[show edit update]
  resource :user_setting, only: %i[edit update]

  root 'static_pages#top'
  get 'terms', to: 'static_pages#terms', as: :terms
  get 'privacy_policy', to: 'static_pages#privacy_policy', as: :privacy_policy

  # LINE通知設定へのルーティング
  get 'line_notification_settings', to: 'line_notifications#edit', as: 'line_notification_settings'
  patch 'line_notification_settings', to: 'line_notifications#update'
  post 'notify_callback', to: 'line_notifications#notify_callback'

  # LINE Bot Webhook URL
  post '/callback', to: 'line_bot#callback'

  # 野菜選択画面へのルーティング
  get 'vegetables', to: 'vegetables#index', as: :vegetables
  get 'vegetables/schedule', to: 'vegetables#schedule', as: :vegetable_schedule

  # Eventsに関するルーティング
  resources :events, only: %i[index show] do
    member do
      get 'advice'
      patch 'complete'
    end
  end

  patch '/events/update_sowing_date', to: 'events#update_sowing_date', as: 'update_sowing_date_events'

  # 画像分析のアクションへのルート
  get 'analyze_image/new', to: 'events#new_analyze_image', as: 'new_analyze_image'
  post 'analyze_image', to: 'events#analyze_image', as: 'analyze_image'

  # 収穫量の入力フォームと節約額の計算結果表示のルーティング
  resources :harvests, only: %i[new create show] do
    collection do
      delete 'destroy_by_vegetable_type'
    end
  end

  # 翻訳用エンドポイント
  post 'translate', to: 'translations#create'

  # 未知のルートをキャッチしてカスタム404エラーページを表示
  match '*path', to: 'application#render_404', via: :all
end

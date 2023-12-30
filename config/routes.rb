Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'user_sessions',
  }

  resources :users, only: [:new, :create]

  root 'static_pages#top'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

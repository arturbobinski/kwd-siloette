Rails.application.routes.draw do

  devise_for :users

  namespace :api do
    resources :users, only: [] do
      get :check_email, on: :collection
    end
  end

  namespace :system do
    resources :pages, only: [:show]
  end

  root to: 'home#index'
end

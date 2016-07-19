Rails.application.routes.draw do

  devise_for :users

  namespace :api do
    resources :users, only: [] do
      get :check_email, on: :collection
    end
    resources :profiles, only: [] do
      get :check_perform_name, on: :collection
    end
  end

  namespace :system, path: '/' do
    resources :users, only: [:show, :edit, :update]
    resources :pages, only: [:show]
  end

  root to: 'home#index'
end

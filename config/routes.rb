Rails.application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'
  ActiveAdmin.routes(self)
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
    resources :services do
      member do
        get :close
        get :open
      end
    end
    resources :users, only: [:show, :edit, :update] do
      member do
        get :become_dancer
        get :media
      end
    end
    resources :service_invitations, only: [:destroy] do
      member do
        get :accept
        get :decline
      end
    end
    resources :service_images, only: [:create, :update, :destroy]
    patch :service_images, to: 'service_images#create'
    resources :pages, only: [:show]
  end

  get :search, to: 'home#search', as: :search

  root to: 'home#index'
end

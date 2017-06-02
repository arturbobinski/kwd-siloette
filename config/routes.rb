Rails.application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', sessions: 'users/sessions'}

  constraints(id: /(miami|las-vegas)/) do
    resources :locations, path: '/', only: [:show]
  end

  namespace :api do
    resources :users, only: [] do
      collection do
        get :check_email
        get :check_slug
      end
    end
    resources :profiles, only: [] do
      get :check_perform_name, on: :collection
    end
    resources :states, only: [:index]

    match 'connect_call' => 'surveys#connect_call', via: [:get, :post]
    match 'get_answer' => 'surveys#get_answer', via: [:get, :post]
    post :get_sms, to: 'messages#get_sms'
  end

  namespace :performer, path: '/' do
    resources :bookings, only: [:index, :show] do
      collection do
        get :calendar
      end
      member do
        get :accept
        get :decline
      end
    end
    resources :reservations, only: [:create, :destroy]
    resources :daily_schedules, only: [:index] do
      put :set_schedule, on: :collection
    end
    resources :services, except: [:show] do
      member do
        get :close
        get :open
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
  end

  namespace :customer do
    resources :bookings do
      member do
        get :cancel
      end
      resources :booking_extensions, only: [:new, :create], path: '/extensions'
    end
    resources :services, only: [] do
      resources :testimonials, only: [:new, :create]
    end
  end

  resources :users, only: [:show, :edit, :update] do
    member do
      get :become_dancer
      get :media
      get :stripe_account
      get :apply
    end
  end
  # resources :countries, path: 'services-in', only: [:show]
  resources :services, only: [:show]
  get :search, to: 'services#search', as: :search
  resources :pages, only: [:show]
  resources :posts, only: [:index, :show], path: '/blog'

  get 'become-a-siloette', to: 'home#work_with_us', as: :work_with_us
  root to: 'home#index'
end

Rails.application.routes.draw do
  devise_for :users
  
  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA routes (commented out for now)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Root path
  root "welcomes#landing"

  # Welcome controller custom routes
  resource :welcomes, only: [] do
    collection do
      get :contact_us
      get :about_us
      get :dashboard
      get :clinic
    end
  end

  # Standard RESTful routes for posts
  resources :posts do
    member do
      post 'like'
      post 'create_comment'
    end
    resources :comments
  end

  # Standard RESTful routes for users
  resources :users do
    collection do
      get :manage_users
      post :add_user
    end

    member do
      patch :deactivate
      patch :activate
      post :follow
      delete :unfollow
    end
  end

  resources :doctors do
    resources :appointments
  end

  resources :patients
  resources :appointments
end


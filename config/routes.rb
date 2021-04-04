Rails.application.routes.draw do
  # root "pages#show", page: "home"   # --- SNN
  
  resources :users do
    collection {post :import} #used for csv importing
  end
  devise_for :userlogins, controllers: {omniauth_callbacks: "userlogins/omniauth_callbacks"}
  devise_scope :userlogin do
    get 'userlogins/sign_in', to: 'userlogins/sessions#new', as: :new_userlogin_session
    get 'userlogins/sign_out', to: 'userlogins/sessions#destroy', as: :destroy_userlogin_session
  end

  
  get 'home/index'
  root to: 'home#index'      
  resources :home
  resources :edithomepages


  match '/pendingApproval', to: 'users#pending_approval', via: [:get, :post], as: :pending_approval
  get '/memberDashboard', to: 'users#member_dashboard', as: :member_dashboard
  get 'user/registration', to: 'users#registration', as: :registration_user
  get '/import', to: 'users#my_import'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :point_event do
  	member do
  		get :delete
      get :qr
      get :attend
      post :attend
      delete '/user/:user_id/destroy' => 'point_event#destroy_user', :as => 'delete_user'
  	end
  end

  resources :event do
  	member do
  		get :delete
      get :qr
      get :attend
      post :attend
      delete '/user/:user_id/destroy' => 'event#destroy_user', :as => 'delete_user'
  	end
  end
end

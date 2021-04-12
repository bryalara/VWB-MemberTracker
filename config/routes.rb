Rails.application.routes.draw do
  get 'officers/index'
  get 'officers/show'
  get 'officers/new'
  get 'officers/edit'
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
  resources :officers
  resources :edithomepages


  match '/pendingApproval', to: 'users#pending_approval', via: [:get, :post], as: :pending_approval
  get '/memberDashboard', to: 'users#member_dashboard', as: :member_dashboard
  get 'user/registration', to: 'users#registration', as: :registration_user
  get '/import', to: 'users#my_import'
  get 'event/csv', to: 'event#export_csv', as: :event_csv
  get 'point_event/csv', to: 'point_event#export_csv', as: :point_event_csv
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :point_event do
    collection {post :import} #used for csv importing
    collection {post :import_part}
  	member do
  		get :delete
      get :qr
      get :attend
      post :attend
      delete '/user/:user_id/destroy' => 'point_event#destroy_user', :as => 'delete_user'
      get :sign_up
      post :sign_up
      post :force_in
      post :upload_user
      patch 'edit', to: 'point_event#update', as: 'update'
    end
  end
  post 'point_event/new', to: 'point_event#create', as: 'create_point_event'

  resources :event do
    collection {post :import} #used for csv importing
    collection {post :import_part}
  	member do
  		get :delete
      get :qr
      get :attend
      post :attend
      delete '/user/:user_id/destroy' => 'event#destroy_user', :as => 'delete_user'
      get :sign_up
      post :sign_up
      post :force_in
      post :upload_user
      patch 'edit', to: 'event#update', as: 'update'
  	end
  end
  post 'event/new', to: 'event#create', as: 'create_event'
  post 'event/download_ics', to: "event#download_ics"
end

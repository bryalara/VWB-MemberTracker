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


  get '/pendingApproval', to: 'users#pendingApproval'
  get '/memberDashboard', to: 'users#memberDashboard'
  get '/import', to: 'users#my_import'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :point_event do
  	member do
  		get :delete
      get :qr
      get :attend
      post :attend
  	end
  end

  resources :event do
  	member do
  		get :delete
      get :qr
      get :attend
      post :attend
  	end
  end
end

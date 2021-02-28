Rails.application.routes.draw do
  
  resources :users do
    collection {post :import} #used for csv importing
  end
  root to: 'users#index'
  devise_for :userlogins, controllers: {omniauth_callbacks: "userlogins/omniauth_callbacks"}
  devise_scope :userlogin do
    get 'userlogins/sign_in', to: 'userlogins/sessions#new', as: :new_userlogin_session
    get 'userlogins/sign_out', to: 'userlogins/sessions#destroy', as: :destroy_userlogin_session
  end

  
  # get 'home/index'
  # root to: 'home#index'            ---SNN
  # resources :home                   ---SNN


  get '/pendingApproval', to: 'users#pendingApproval'
  get '/import', to: 'users#my_import'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :point_event do
  	member do
  		get :delete
  	end
  end

  resources :event do
  	member do
  		get :delete
  	end
  end
  # root "pages#show", page: "home"   # --- SNN
  get "/pages/:page" => "pages#show"
  
end

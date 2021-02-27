Rails.application.routes.draw do
  get '/pendingApproval', to: 'users#pendingApproval'
  get '/import', to: 'users#my_import'
  resources :users do
    collection {post :import}
  end
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
end

Rails.application.routes.draw do
  resources :canteens
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  scope :user do
    post :register, to: 'user#register', as: :user_register
    post :login, to: 'user#login', as: :user_login
    post :logout, to: 'user#logout', as: :user_logout
    get :get_information, to: 'user#information', as: :get_information
  end

  scope :dishes do
    post :create, to: 'dish#create', as: :dish_create
    get :list, to: 'dish#list', as: :dish_list
    delete :delete, to: 'dish#delete', as: :dish_delete
    post :update, to: 'dish#update', as: :dish_update
  end

end

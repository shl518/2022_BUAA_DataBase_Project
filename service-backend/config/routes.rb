Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  scope :user do
    post :register, to: 'user#register', as: :user_register
    post :login, to: 'user#login', as: :user_login
  end
end

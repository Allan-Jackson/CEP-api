Rails.application.routes.draw do
  get 'enderecos/:cep', to: 'enderecos#show'
  get 'enderecos', to: 'enderecos#index'

  post 'auth', to: 'auth#create_token'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end

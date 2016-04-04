Rails.application.routes.draw do
  root "static_pages#home"
  get "about" => "static_pages#about"
  get "contact" => "static_pages#contact"
  get "help" => "static_pages#help"

  namespace :admin do
    root "static_pages#home"
    resources :users
    resources :categories
    resources :questions
  end

  devise_for :users, path: "",
    path_names: {sign_in: "login", sign_out: "logout"}
  resources :users, only: [:show, :index]
  resources :categories, only: [:index]
  resources :exams, except: [:destroy]
  resources :answers, only: [:index]
  resources :questions, only: [:index]
  resources :relationships, only: [:index, :create, :destroy]
end

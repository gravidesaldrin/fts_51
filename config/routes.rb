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

  resources :users, only: [:show, :index]
  devise_for :users, path: "",
    path_names: {sign_in: "login", sign_out: "logout"}
  resources :categories, only: [:index]
  resources :exams, except: [:destroy]
  resources :answers, only: [:index]
end

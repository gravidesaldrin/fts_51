Rails.application.routes.draw do
  root "static_pages#home"
  get "about" => "static_pages#about"
  get "contact" => "static_pages#contact"
  get "help" => "static_pages#help"
  devise_for :users, path: "",
    path_names: {sign_in: "login", sign_out: "logout"}
end

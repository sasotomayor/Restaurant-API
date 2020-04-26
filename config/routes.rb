Rails.application.routes.draw do
  resources :burgers do
    resources :ingredients, :except => [:index, :create, :show]
  end
  resources :ingredients, :except => [:update]
end

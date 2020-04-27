Rails.application.routes.draw do
  get 'hamburguesa' => 'burgers#index'
  post 'hamburguesa' => 'burgers#create'
  get 'hamburguesa/:id' => 'burgers#show'
  delete 'hamburguesa/:id' => 'burgers#destroy'
  patch 'hamburguesa/:id' => 'burgers#update'
  delete 'hamburguesa/:burger_id/ingrediente/:id' => 'ingredients#destroy'
  put 'hamburguesa/:burger_id/ingrediente/:id' => 'ingredients#update'
  get 'ingrediente' => 'ingredients#index'
  post 'ingrediente' => 'ingredients#create'
  get 'ingrediente/:id' => 'ingredients#show'
  delete 'ingrediente/:id' => 'ingredients#destroy'
end

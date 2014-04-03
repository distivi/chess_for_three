ChessForThree::Application.routes.draw do
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  # resources :rooms 
  resources :desk,  only: [:show, :new, :destroy] do
    member do
      get 'select_figure'
      get 'move_figure'
    end
  end

  root 'sessions#new'

  match '/signup',  to: 'users#new',            via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'

  # match '/rooms',   to: 'rooms#index',          via: 'get'
  # match '/new_room',to: 'rooms#new',            via: 'get'

  # match '/rooms/:id/take_place', to: 'rooms#take_place', :action => 'take_place', via: 'post'
  # match '/rooms/:id/leave',      to: 'rooms#leave',      :action => 'leave',      via: 'post'

  match '/game',    to: 'game#main',            via: [:get, :post]

  # post 'game/send_message'
  match '/send_message', to: 'game#send_message', via: :post
  match '/leave_chat',   to: 'game#leave_chat',   via: :post

  match '/main',         to: 'main#index',        via: :get
  match '/random_game',  to: 'main#random_game',  via: :get




  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end

Rails.application.routes.draw do
  devise_for :users

  root 'home#index'

  resources :users
  resources :catalogs
  resources :templates
  resources :semesters

  resources :courses do
    collection { post :do_import }
  end

  resources :requirements, only: [:do_import] do
    collection { post :do_import }
  end

  get '/predict' => 'predict#index'
  post '/predict/run' => 'predict#run'

  get 'manage' => 'home#manage'
  get 'help' => 'home#help'

  get 'import',               to: "importer#index"
  get 'import/courses',       to: 'importer#courses'
  get 'import/requirements',  to: 'importer#reqs'

  get 'courses_by_semester/:id' => 'courses#by_semester', as: 'courses_by_semester'
  get 'all_courses' => 'courses#all_courses'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#new2'

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

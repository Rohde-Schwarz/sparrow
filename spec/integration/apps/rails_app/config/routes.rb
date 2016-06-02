Rails.application.routes.draw do
  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action
  
  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)
  
  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  
  # Sample resource route with options:
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
  
  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end
  
  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end
  
  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
  
  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root to: 'welcome#index', defaults: {format: 'json'}
  post '/posts', to: 'welcome#posts', defaults: {format: 'json'}
  get '/welcome', to: 'welcome#show', defaults: {format: 'json'}
  get '/welcome/non_json_text_response', to: 'welcome#non_json_text_response' #, defaults: {format: 'json'}
  get '/welcome/non_json_binary_response', to: 'welcome#non_json_binary_response' #, defaults: {format: 'json'}
  get '/array_of_elements', to: 'welcome#array_of_elements', defaults: {format: 'json'}
  get '/upcase_first_name', to: 'welcome#upcase_first_name', defaults: {format: 'json'}
  get '/ignore', to: 'welcome#ignore', defaults: {format: 'json'}
  get '/ignore/non_json_text_response', to: 'welcome#non_json_text_response' # , defaults: {format: 'json'}
  get '/ignore/non_json_binary_response', to: 'welcome#non_json_binary_response' #, defaults: {format: 'json'}
  get '/error', to: 'errors#error', defaults: {format: 'json'}
  get '/error-507', to: 'errors#error_507'
end
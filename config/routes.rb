Rails.application.routes.draw do

	#root 'sessions#new'
	
	#
	# 전환할 때 이변수 두개 왔다 갔다
	#root 'posts#notice' 
	root 'posts#index' 

	resources :backgrounds, only: [:create, :new, :destroy]

	resources :friendships, only: [:create, :destroy]
	get 'friendships/:id/:type' => 'friendships#show'

	resources :users do
		resources :projects
	end

	resources :projects do
		resources :plikes, only: [:create]
	end

	get '/tag_search' => "posts#tag_search"

	get '/events' => "users#events"

	get '/auth_user/:auth_key'=> "users#auth_user"

	get '/user_search' => 'users#search', as: 'users_search'
	post '/user_search' => 'users#search'

	resources :posts do
		resources :comments, only: [:create, :destroy]
		resources :likes, only: [:create]
		resources :shares, only: [:create]
	end

	resources :photos , only: [:destroy]

	get '/timeline' => 'posts#timeline'
	get '/college' => 'posts#college'
	get '/editor' => 'posts#editor'
	get '/links' => 'posts#links'

	# 링크 인풋을 받기 위해서
	post '/link_create' => 'posts#link_create'

	# /posts를 앞에 붙이면 위에거랑 겹쳐서 문제가 되어 /my_feeld로 독립시켰다
	get '/my/:mf_id' => 'posts#mf_redirect'
	get '/my_feeld' => 'posts#my_feeld'
	get '/my_feeld/:user_id' => 'posts#my_feeld'
	get '/message_box/:user_id' => 'posts#message_box'
	get '/archive_mine' => 'posts#archive_mine'
	get '/archive_share' => 'posts#archive_share'
	get '/project_management' => 'posts#project_management'
	get '/project_list_in' => 'posts#project_list_in'



	get '/login' => "sessions#new"
	post '/login' => "sessions#create_normal"
	get '/auth/:provider/callback' => 'sessions#create_facebook'
	delete '/logout', to: 'sessions#destroy'

	get 'welcome/test/930911' => 'welcome#test'
	get '/state' => 'welcome#state'


	get '/notice' => 'posts#notice'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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

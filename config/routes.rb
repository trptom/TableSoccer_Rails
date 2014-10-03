TableSoccer::Application.routes.draw do
  get "stats/players"
  get "stats/player"
  get "stats/team"
  match 'stats/players/:id/:season' => 'stats#players'
  match "stats/players/:id" => 'stats#players'
  match 'stats/player/:id/:season' => 'stats#player'
  match "stats/player/:id" => 'stats#player'
  match 'stats/team/:id/:season' => 'stats#team'
  match "stats/team/:id" => 'stats#team'
  
  get "user_sessions/create"
  get "user_sessions/destroy"

  get "home/index"

  resources :games

  resources :matches do
    member do
      post :add_all_games
    end
  end

  resources :league_teams

  resources :players

  resources :game_players

  resources :teams

  resources :leagues

  resources :user_sessions

  resources :users do
    collection do
      get :login
    end
    member do
      get :activate
      get :activate_manually
    end
  end

  match 'matches/:id/add_game' => 'matches#add_game'
  match 'leagues/:id/draw' => 'leagues#draw', :as => :draw_league
  
  match 'login' => 'user_sessions#create', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout
  match 'register' => 'users#new', :as => :register
  match 'current_user' => 'users#show', :as => :current_user
  match 'home' => 'home#index', :as => :home
  
  get "oauths/oauth"
  get "oauths/callback"
  match "oauth/callback" => "oauths#callback"
  match "oauth/:provider" => "oauths#oauth", :as => :auth_at_provider

  root :to => 'home#index'

  # The priority is based upon order of creation:
  # first created -> highest priority.

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end

TableSoccer::Application.routes.draw do
  scope "(:locale)", locale: /cs|en/ do
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
        get :add_possible_date
        get :view
      end

      collection do
        get :update_possible_date
        get :remove_possible_date
      end
    end

    resources :league_teams

    resources :players do
      member do
        post :add_black_dot
        post :pay_beer
      end
    end

    resources :game_players

    resources :teams do
      member do
        get :matches, :as => :matches_of_team
        get :squad
        get :recount_money
      end
    end

    resources :leagues

    resources :user_sessions

    resources :users do
      collection do
        get :login
        get :reset_password # TODO zjistil jsem, ze to nejak nefunguje... :-/
        post :add_attendance
        post :remove_attendance
      end
      member do
        get :activate
        get :activate_manually
        get :fill_attendance
      end
    end

    resources :comments do
      member do
        get :hide
      end
    end

    match 'matches/remove_possible_date/:id' => 'matches#remove_possible_date'
    match 'matches/update_possible_date/:id' => 'matches#update_possible_date'

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
  end

  get '/:locale' => 'home#index'
  root :to => 'home#index'
end

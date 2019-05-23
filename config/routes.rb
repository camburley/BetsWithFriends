Rails.application.routes.draw do
  root to: 'home#index'
  
  # ADMIN
  match '/admin' => 'admin#dashboard', :via => [:get, :post]
  match '/admin/add_players' => 'admin#add_players', :via => [:get, :post]
  
  # MESSENGER WEBHOOK
  match '/webhook' => 'messenger#callback', :via => :post
  get '/webhook' => 'messenger#verify_callback'
  
  # FACEBOOK LOGIN
  match 'auth/facebook/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]
  
  #BETS
  get '/bet/:user_id' => 'bet#index', as: 'bet'
  get '/detail_bet/:user_id' => 'bet#detail_bet'
  get '/get_user' => 'bet#get_user'
  get '/quick_picks/:user_id' => 'bet#quick_picks'
  get '/games/:user_id' => 'bet#games'
  match '/pick_team/:user_id' => 'bet#pick_team', :via => [:get, :post]
  match '/create_league/:user_id' => 'bet#create_league', via: [:get, :post]
  get '/account/:user_id' => 'bet#account', as: 'bet_account'
  get '/leaderboard/:league_id' => 'bet#leaderboard'
  match '/accept_league/:league_id' => 'bet#accept_league', via: [:get, :post]
  
  match '/bet/create/:game_id' => 'bet#create', :via => [:get, :post], as: 'bet_create'
  match '/bet/accept/:bet_id' => 'bet#accept', :via => [:get, :post], as: 'bet_accpet'
  get '/bet/result/:bet_id' => 'bet#result', as: 'bet_result'
  get '/bet/rules' => 'bet#rules', as: 'bet_rules'
  
  # IF ROUTES NOT EXISTS
  get '*path' => redirect('/')
end

class BetController < ApplicationController
    before_action :allow_facebook_iframe
    layout "bet"
    
    def index
        if User.find_by(:sender_id => params[:user_id])
            @title = "Fantasy Sports w/ Friends"
            @games = Game.limit(100).order('created_at DESC')
            @user = User.find_by(:sender_id => params[:user_id])
            @bets = Bet.where(:user_id => @user.id).or(Bet.where(:opponent => @user.id)).where.not(:opponent => nil).where(:closed => false).order('created_at DESC')
        end
    end
    
    def get_user
        @title = "Gathering Data"
        @page = params[:page]
    end
    
    def quick_picks
       @title = "HEAD TO HEAD" 
       @games = Game.where.not(:game_type => "NFL_FF").limit(100).order('created_at DESC')
    end
    
    def games
        if User.find_by(:sender_id => params[:user_id])
           @title = "Pick Daily Game"
           @games = Game.where(:game_type => "NFL_FF")
           @user = User.find_by(:sender_id => params[:user_id])
        else
           redirect_to bet_path(params[:user_id])
        end
    end
    
    def pick_team
        if Time.now.wday == 1 && Time.now > Time.now.beginning_of_day + 20.hours
            week = (Time.now).strftime('%W').to_i - 35
        else
            week = (Time.now - 1.day).strftime('%W').to_i - 35
        end
        
        if User.find_by(:sender_id => params[:user_id]) && Game.find_by(:id => params[:game_id]) && params[:day]
            @title = "Pick Team#{params[:games]}"
            @user = User.find_by(:sender_id => params[:user_id])
            @game = Game.find_by(:id => params[:game_id])
            @wagers = [":beer: Beer", ":cocktail: Drink", ":fork_knife_plate: Order Food", ":coffee: Covfefe", ":eggplant: ...eggplant", ":tongue: ...",  ":ghost: Private Snap", ":weary: Groveling Apology",  ":punch: Punch", ":wave: Handshake", ":herb: Herbs" ]
            #":tropical_drink: Mixed Drink", ":fries: Fries", ":sushi: Sushi", ":pizza: Pizza", ":hamburger: Burger", ":cake: Cake", ":egg: Brunch", ":fried_shrimp: Hibachi", ":iphone: Go Live",  ":newspaper: Subscription", ":ticket: Concert", ":sunglasses: Sunglasses", ":wine_glass: Vino", ":camera: Selfie",
            
            if params[:day] == "10" 
                day = [1, 0]
                @schedules = Schedule.where(:game_day => day, :week => week).where.not(:away_team => nil, :home_team => nil, :game_time => nil).where("game_time > ?", Time.now).order('game_time ASC').limit(14)
            elsif params[:day] == "7"
                day = (0..6).to_a
                @schedules = Schedule.where(:game_day => day, :week => week).where.not(:away_team => nil, :home_team => nil, :game_time => nil).where(:game_time => Time.now..Time.now + 7.days).order('game_time ASC')
            else 
                day = params[:day]
                @schedules = Schedule.where(:game_day => day, :week => week).where.not(:away_team => nil, :home_team => nil, :game_time => nil).where("game_time > ?", Time.now).order('game_time ASC').limit(14)
            end
            
            if @schedules.count > 1
                teams = @schedules.pluck(:away_team, :home_team).flatten.uniq
            elsif @schedules.count == 1
                teams =  [@schedules.first.away_team, @schedules.first.home_team]
            end
            
            @players = Player.where(:team => teams, :position => @game.options)
            
        elsif params[:bet_id] && Bet.find_by(:id => params[:bet_id])
            if User.find_by(:sender_id => params[:user_id])
                @user = User.find_by(:sender_id => params[:user_id])
            else 
                uri = URI.parse("https://graph.facebook.com/v2.10/#{params[:user_id]}?fields=first_name,last_name,profile_pic,locale,gender,timezone&access_token=#{ENV['ACCESS_TOKEN']}")
                response = Net::HTTP.get_response(uri)
                data = JSON.parse(response.body)
                
                @user = User.create(sender_id: params[:user_id], first_name: data["first_name"], last_name: data["last_name"], gender: data["gender"], locale: data["locale"], timezone: data["timezone"], profile_picture: data["profile_pic"], role: "user") 
            end
        
            @bet = Bet.find_by(:id => params[:bet_id])
            @game = Game.find_by(:id => @bet.game_id)
            @creator = User.find_by(:id => @bet.user_id)
            @title = "#{@creator.first_name} challenged you!"
            
            if @bet.day == "10" 
                day = [1, 0]
                @schedules = Schedule.where(:game_day => day, :week => week).where.not(:away_team => nil, :home_team => nil, :game_time => nil).where("game_time > ?", Time.now).order('game_time ASC').limit(14)
            elsif @bet.day == "7"
                day = (0..6).to_a
                @schedules = Schedule.where(:game_day => day, :week => week).where.not(:away_team => nil, :home_team => nil, :game_time => nil).where(:game_time => Time.now..Time.now + 7.days).order('game_time ASC')
            else 
                day = @bet.day
                @schedules = Schedule.where(:game_day => day, :week => week).where.not(:away_team => nil, :home_team => nil, :game_time => nil).where("game_time > ?", Time.now).order('game_time ASC').limit(14)
            end
            
            if @schedules.count > 1
                teams = @schedules.pluck(:away_team, :home_team).flatten.uniq
            elsif @schedules.count == 1
                teams =  [@schedules.first.away_team, @schedules.first.home_team]
            end
            
            @players = Player.where(:team => teams, :position => @game.options)
        else
            redirect_to bet_path
        end
        
        if request.post? && User.find_by(:sender_id => params[:user_id])
           if params[:create] == "true" && Game.find_by(:id => params[:game_id])
               
              @game = Game.find_by(:id => params[:game_id])
              user = User.find_by(:sender_id => params[:user_id])
              
              bet = Bet.create(:user_id => user.id, :game_id => params[:game_id], :wage => params[:wage], :user_picked => params[:players], :day => params[:day], :week => week, :game_time => params[:game_time], :resolved => false, :accepted => false, :notifications => true)
              
              render json: {'success': true, 'user_name': user.first_name, 'bet_id': bet.id, 'wage': bet.wage }, status: :ok
            elsif params[:accept] == "true" && Bet.find_by(:id => params[:bet_id])
              bet = Bet.find_by(:id => params[:bet_id])
              user = User.find_by(:sender_id => params[:user_id])
              
              bet.update_attributes(:opponent => user.id, :opponent_picked => params[:players], :accepted => true)
              
              if bet.notifications == true
                    user = User.find_by(:id => bet.user_id)
                    opponent = User.find_by(:id => bet.opponent)
                    
                    MessengerController::Send.new.text_message(user.sender_id, "#{opponent.first_name} has just accepted your challenge! Check live scores using the menu.")
                    MessengerController::Send.new.text_message(opponent.sender_id, "Your game with #{user.first_name} is now official! Check live scores using the menu.")
              end
              
              render json: {'success': true}, status: :ok
           end
        end
    end
    
    def create_league
        @title = "CREATE LEAGUE"
        
        if request.post? && params[:create_league] == "true" && User.find_by(:sender_id => params[:user_id])
            user = User.find_by(:sender_id => params[:user_id])
            players = []
            players << user.id
            
            league = League.create(:user_id => user.id, :title => params[:title], :players => players)
            
            render json: {'league_id': league.id}, status: :ok
        end
    end
    
    def leaderboard
       if League.find_by(:id => params[:league_id])
           @league = League.find_by(:id => params[:league_id])
           
           @title = @league.title.upcase
           @user = User.find_by(:id => @league.user_id)
           @league_players = User.where(:id => @league.players)
       end
    end
    
    def accept_league
        if League.find_by(:id => params[:league_id])
           @title = "LEAGUE INVITATION"
           @league = League.find_by(:id => params[:league_id])
           @user = User.find_by(:id => @league.user_id)
           
           array = []
           @league.players.each do |player|
              array << User.find_by(:id => player).sender_id
           end
           
           @player_array = array.map(&:to_i)
        end
        
        if request.post? && League.find_by(:id => params[:league_id]) && User.find_by(:sender_id => params[:user_id])
            league = League.find_by(:id => params[:league_id])
            creator = User.find_by(:id => league.user_id)
            user = User.find_by(:sender_id => params[:user_id])
            
            unless creator.friends.include? "#{user.id}"
                creator.friends << user.id
                creator.save!
            end
            
            unless user.friends.include? "#{creator.id}"
                user.friends << creator.id
                creator.save!
            end
            
            unless user.user_leagues.include? "#{league.id}"
                user.user_leagues << league.id
                user.save!
            end
           
            unless league.players.include? "#{user.id}"
                league.players << user.id
                league.save!
            end
            
            render json: {"success": true}, status: :ok
        end
    end
    
    def create
        @title = "CREATE NEW"
        
        if Game.find_by(:id => params[:game_id]) 
           @game = Game.find(params[:game_id]) 
           @wagers = [":beer: Beer", ":wine_glass: Vino", ":cocktail: Drink", ":tropical_drink: Mixed Drink", ":fries: Fries", ":sushi: Sushi", ":pizza: Pizza", ":hamburger: Burger", ":cake: Cake", ":fork_knife_plate: Order Food", ":egg: Brunch", ":coffee: Covfefe", ":eggplant: ...eggplant", ":fried_shrimp: Hibachi", ":tongue: ...", ":camera: Selfie",  ":weary: Groveling Apology", ":iphone: Go Live",  ":newspaper: Subscription", ":ticket: Concert", ":sunglasses: Sunglasses", ":punch: Punch", ":wave: Handshake", ":ghost: Private Snap", ":herb: Herbs" ]
        else
            redirect_to bet_path
        end
        
        if request.post?
            if params[:game_id] && params[:create] == "true" && User.find_by(:sender_id => params[:token])
                user = User.find_by(:sender_id => params[:token])
                bet = Bet.create(:user_id => user.id, :game_id => params[:game_id], :wage => params[:wage], :user_picked => params[:picked], :resolved => false, :accepted => false, :notifications => true )
                render json: {'success': true, 'user_name': user.first_name, 'bet_id': bet.id }, status: :ok
            end
        end
    end
    
    def accept
        if Bet.find_by(:id => params[:bet_id]) && Game.find_by(:id => Bet.find(params[:bet_id]).game_id)
            @bet = Bet.find(params[:bet_id])
            @game = Game.find_by(:id => @bet.game_id)
            @user = User.find(@bet.user_id)
            unless @bet.opponent.nil?
                @opponent = User.find(@bet.opponent)
            end
            
            @title = "#{@user.first_name.upcase} CHALLENGES YOU"
        else 
            redirect_to bet_path(@user.sender_id)
        end
        
        if params[:accept] == "true"
            if User.find_by(:sender_id => params[:token]) != Bet.find_by(:id => params[:bet_id]).user_id
                
                unless User.find_by(:sender_id => params[:token])
                    uri = URI.parse("https://graph.facebook.com/v2.6/#{params[:token]}?fields=first_name,last_name,profile_pic,locale,gender,timezone&access_token=EAADHc47ZA11YBAGhugoBEuGZCoYNUPe6Se8cFDdwfeZASUkHekVmZCxZBTszmeDTYJplaMR0IkBnzEVIU6ZBVltDfpS3Q7s6sJDMLkyY0mDzDWyNye8ZCCB0i8JvSjlOxAmZB7GQapCYbnjM8I8xWMCmjkZAJkjKUeZCBTw3zeR3vJXwZDZD")
                    response = Net::HTTP.get_response(uri)
                    data = JSON.parse(response.body)
                        
                    User.create(sender_id: params[:token], first_name: data["first_name"], last_name: data["last_name"], gender: data["gender"], locale: data["locale"], timezone: data["timezone"], profile_picture: data["profile_pic"])
                end
                
                bet = Bet.find_by(:id => params[:bet_id])
                    
                user = User.find_by(:sender_id => params[:token])
                creator = User.find_by(:id => bet.user_id)
                option = bet.user_picked == "option_a" ? "option_b" : "option_a"
                
                Bet.find(params[:bet_id].to_i).update_attributes(:opponent => user.id, :opponent_picked => option, :accepted => true)
                
                unless creator.friends.include? "#{user.id}"
                    creator.friend << user.id
                    creator.save!
                end
                
                unless user.friends.include? "#{creator.id}"
                    user.friend << creator.id
                    creator.save!
                end
                
                if bet.notifications == true
                    user = User.find_by(:id => bet.user_id)
                    opponent = User.find_by(:id => bet.opponent)
                    
                    MessengerController::Send.new.text_message(user.sender_id, "#{opponent.first_name} has just accepted your challenge!") 
                end
                
                render json: {'success': true}, status: :ok
            end
        end
    end
    
    def result
        if Bet.find_by(:id => params[:bet_id]) && Game.find_by(:id => Bet.find(params[:bet_id]).game_id)
            @title = "THREAD.GAMES"
            
            @bet = Bet.find(params[:bet_id])
            @game = Game.find(@bet.game_id)
            @user = User.find(@bet.user_id)
            @wins = Bet.where(:user_id => [@bet.user_id, @bet.opponent], :opponent => [@bet.user_id, @bet.opponent], :closed => true).pluck(:winner)
        else
            redirect_to bet_path
        end
    end
    
    def account
        if User.find_by(:sender_id => params[:user_id])
            @title = "My Account"
            @user = User.find_by(:sender_id => params[:user_id])
            @bets = Bet.where(:user_id => @user.id).or(Bet.where(:opponent => @user.id)).where.not(:opponent => nil).order('created_at DESC')
            @leagues = League.where(:id => @user.user_leagues).order('created_at DESC')
            @wins = @bets.where(:winner => @user.id)
            @losses = @bets.where.not(:winner => @user.id)
            @active = @bets.where(:winner => nil).where.not(:opponent => nil)
        else
            redirect_to bet_path
        end 
    end
    
    def detail_bet
        if User.find_by(:sender_id => params[:user_id]) && params[:bet_id]
            @title = "Live Details"
            @bet = Bet.find_by(:id => params[:bet_id])
        else
           redirect_to bet_path
        end
    end
    
    def rules
        @title = "CHALLANGE RULES"
    end
    
    private

      def allow_facebook_iframe
        response.headers['X-Frame-Options'] = 'ALLOWALL'
      end
end

class AdminController < ApplicationController
    before_action :is_admin?
    layout "admin"
    
    def dashboard
        
        if request.post?
            start_date = params[:start_date] == "" ? Time.now : params[:start_date]
            expiration_date = params[:expiration_date] == "" ? Time.now + 1.day : params[:expiration_date]
            budget = params[:budget] == "" ? nil : params[:budget]
            
            Game.create(:admin_id => current_admin.id,
                        :game_type => params[:contest_type], 
                        :title => params[:title],
                        :description => params[:description],
                        :budget => budget,
                        :image => params[:image],
                        :start_date => start_date,
                        :expiration_date => expiration_date,
                        :validation_url => params[:validation_url],
                        :options => params[:options]
                        )
        end
    end
    
    def add_players
        require 'csv'
        require 'json'
        
        if request.post? && params[:file]
            if params[:file_type] == "Players" || params[:file_type] == "Salaries"
                file_type = params[:file_type]
                file = params[:file]
                
                respond_to do |format|
                    if file.respond_to?(:read)
                      json = CSV.open(file.path, :headers => true).map { |x| x.to_h }.to_json
                      JSON.parse(json).each do |player|
                        if file_type == "Players" && player["ID"]
                            if Player.find_by(:player_id => player["ID"])
                                pl = Player.find_by(:player_id => player["ID"])
                                Score.create( :player_id => pl.id, :week => player["Week"], :games => player["Gms"], :pass_yards => player["Pass Yds"], :touchdowns => player["TD"], :interceptions => player["Int"], :rush_yards => player["Rush Yds"], :receptions => player["Rec"], :reception_yards => player["Yds"], :sacks => player["Sck"], :ppg => player["PPG"], :fantasy_points => player["Fantasy Points"] )
                            else
                                pl = Player.create( :player_id => player["ID"], :name => player["Player"], :position => player["Pos"], :team => player["Team"], :salary => [], :prediction => [] )
                                Score.create( :player_id => pl.id, :week => player["Week"], :games => player["Gms"], :pass_yards => player["Pass Yds"], :touchdowns => player["TD"], :interceptions => player["Int"], :rush_yards => player["Rush Yds"], :receptions => player["Rec"], :reception_yards => player["Yds"], :sacks => player["Sck"], :ppg => player["PPG"], :fantasy_points => player["Fantasy Points"] )
                            end
                            
                            # bets = Bet.where(:accepted => true, :closed => false).where.not(:user_id => nil, :opponent => nil)
                            # bets.each do |bet|
                            #     if User.find_by(:id => bet.user_id) && User.find_by(:id => bet.opponent) && bet.notifications == true
                            #         creator = User.find_by(:id => bet.user_id)
                            #         opponent = User.find_by(:id => bet.opponent)
                                   
                            #       #  user_score = Score.get_scores(bet.user_picked)
                            #       #  opponent_score = Score.get_scores(bet.opponent_picked)
                                     
                            #         schedule = Schedule.first_game(bet.day).game_time
                                     
                            #         unless schedule + 195.minutes > Time.now 
                            #             if schedule + 180.minutes > Time.now
                            #                 if bet.notifications == true
                            #               #   MessengerController::Send.new.text_message(opponent.sender_id, "#{creator.first_name} winning more than 10 points!")
                            #                   MessengerController::Send.new.game_notification(creator.sender_id, Game.find_by(:id => bet.game_id).image)
                            #                   MessengerController::Send.new.game_notification(opponent.sender_id, Game.find_by(:id => bet.game_id).image)
                            #                 end
                            #             elsif schedule + 90.minutes > Time.now
                            #                 if bet.notifications == true
                            #                   MessengerController::Send.new.game_notification(creator.sender_id, Game.find_by(:id => bet.game_id).image)
                            #                   MessengerController::Send.new.game_notification(opponent.sender_id, Game.find_by(:id => bet.game_id).image)
                            #               #   MessengerController::Send.new.text_message(opponent.sender_id, "#{creator.first_name} losing more than 10 points!")
                            #                 end
                            #             end
                            #         end
                            #     end
                            # end
                             
                            
                            format.html  { redirect_to admin_add_players_path, notice: 'Players added & Score updated!' }
                        elsif file_type == "Salaries" && player["ID"]
                            if Player.find_by(:player_id => player["ID"])
                                pl = Player.find_by(:player_id => player["ID"])
                                pl.update_attributes(:opponent => player["Opp"])
                                pl.salary << { "week_#{player["Week"]}": player["Salary"] }
                                pl.prediction << { "week_#{player["Week"]}": player["Projection"] }
                                pl.save!
                            else
                                pl = Player.create(:player_id => player["ID"], :name => player["Player"], :position => player["Pos"], :team => player["Team"], :opponent => player["Opp"], :salary => [], :prediction => [] )
                                pl.salary << { "week_#{player["Week"]}": player["Salary"] }
                                pl.prediction << { "week_#{player["Week"]}": player["Projection"] }
                                pl.save!
                            end
                            
                            format.html  { redirect_to admin_add_players_path, notice: 'Salaries added!' }
                        else
                            format.html  { redirect_to admin_add_players_path, notice: 'Missing player IDs!' }
                        end
                      end
                    else
                      format.html  { redirect_to admin_add_players_path, notice: 'Wrong file format!' }
                    end
                end
            end
        end
    end
    
    
    private
        def is_admin?
           redirect_to root_path unless current_admin
        end
end

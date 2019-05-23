class Bet < ApplicationRecord
    belongs_to :user
    belongs_to :game
    
    if Time.now.wday == 1 && Time.now > Time.now.beginning_of_day + 20.hours
        @week = (Time.now).strftime('%W').to_i - 35
    else
        @week = (Time.now - 1.day).strftime('%W').to_i - 35
    end
    
    def self.close_bets
        bets = where(:closed => false, :accepted => true, :week => @week)
        
        bets.each do |bet|
            if bet.day == "7" || bet.day == "10"
                close_day = 2
            else
                close_day = bet.day.to_i + 1    
            end
            
            if close_day == Date.today.wday
                user_score = Score.get_scores(bet.user_picked, bet.week)
                opponent_score = Score.get_scores(bet.opponent_picked, bet.week)
                
                if user_score > opponent_score
                    bet.update_attributes(:winner => bet.user_id) 
                else
                    bet.update_attributes(:winner => bet.opponent)
                end
                
                bet.update_attributes(:user_score => user_score, :opponent_score => opponent_score, :closed => true)
            end
        end
    end
    
    def self.gamestart_alert 
        active_bets = where(:accepted => true, :closed => false, :day => Date.today.wday, :week => @week, :notifications => true)
        time_now = Time.now
        
        active_bets.each do |bet|
            if bet.game_time.between?(time_now, time_now + 45.minutes)
                creator = User.find_by(:id => bet.user_id)
                opponent = User.find_by(:id => bet.opponent)
                MessengerController::Send.new.text_message(opponent.sender_id, Rumoji.decode(" :football: #{creator.first_name} it\'s Gametime again and you\'ve got players Check out Live Scores below"))
                MessengerController::Send.new.text_message(creator.sender_id, Rumoji.decode(":football: #{opponent.first_name} it\'s Gametime again and you\'ve got players. Check out Live Scores below"))
            end
         end 
    end
end
class Schedule < ApplicationRecord
    
    def self.first_game(day, week)
        if day == "7"
            day = (1..6).to_a
        elsif day == "10"
            day = [1, 0]
        end
        
        return where(:week => week, :game_day => day).where.not(:game_time => nil).first
    end
    
    def self.last_game(day, week)
        if day == "7"
            day = (1..6).to_a
        elsif day == "10"
            day = [1, 0]
        end
        
        return where(:week => week, :game_day => day).where.not(:game_time => nil).last
    end
    
    def update_schedule
        require 'json'
        file = JSON.parse(File.open("./schedule.json", "r").read)
            
        file.each do |schedule|
            unless Schedule.find_by(:week => schedule["Week"], :away_team => schedule["AwayTeam"], :home_team => schedule["HomeTeam"])
                unless schedule["Date"].nil?
                    date_time = Time.parse(schedule["Date"]) - Time.zone_offset('EST')
                end
                game = Schedule.create(:week => schedule["Week"], :game_time => date_time, :away_team => schedule["AwayTeam"], :home_team => schedule["HomeTeam"])
                unless game.game_time.nil?
                    day = game.game_time.strftime("%u")
                    game.update_attributes(:game_day => day)
                end
            else
                game = Schedule.find_by(:week => schedule["Week"], :away_team => schedule["AwayTeam"], :home_team => schedule["HomeTeam"])
                unless game.game_time.nil?
                    day = game.game_time.strftime("%u")
                    game.update_attributes(:game_day => day)
                end
            end
        end
    end
end
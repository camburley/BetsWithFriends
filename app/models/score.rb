class Score < ApplicationRecord
    belongs_to :player
    
    def self.get_scores(players, week)
        scores = []
        
        players.each do |player|
            if Player.find_by(:id => player) && Player.find(player).scores.any? && Player.find(player).scores.last.week == week
                scores << Player.find(player).scores.last.fantasy_points
            else
               scores << 0
            end
        end
        
        return scores.inject(0, :+)
    end
    
    def self.get_score(player, week)
        if Player.find_by(:id => player) && Player.find(player).scores.any? && Player.find(player).scores.last.week == week
           return Player.find(player).scores.last.fantasy_points
        else
           return 0
        end
    end
end

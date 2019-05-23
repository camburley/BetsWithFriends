class Game < ApplicationRecord
    belongs_to :admin
    has_many :games
end

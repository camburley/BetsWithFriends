class Admin < ApplicationRecord
    has_many :games
    has_many :fantasy_games
    
    def self.create_with_omniauth(auth)
        admin = find_or_create_by(fb_id: auth['uid'], provider:  auth['provider'])
        admin.fb_token = auth['credentials']['token']
        admin.first_name = auth['extra']['raw_info']['first_name']
        admin.last_name = auth['extra']['raw_info']['last_name']
        admin.profile_picture = auth['info']['image']
        
        if admin
            if admin.fb_token == auth['credentials']['token']
                admin.update_attributes(:fb_token => auth['credentials']['token'])
            elsif admin.first_name.nil? || admin.last_name.nil? || admin.profile_picture.nil?
                admin.update_attributes(:first_name => auth['extra']['raw_info']['first_name'], 
                                        :last_name => auth['extra']['raw_info']['last_name'],
                                        :profile_picture => auth['info']['image'])
            end
            
            admin
        else
            admin.save!
            admin
        end
    end
end

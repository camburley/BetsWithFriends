class Messenger::PostBack
  extend ActiveModel::Naming
  Send = MessengerController::Send.new
  
  def initialize(sender_id, payload)
    
    # GET STARTED PAYLOAD FOR USERS / NON USERS
    if payload =~ /^GET_STARTED_PAYLOAD/
      unless User.find_by(:sender_id => sender_id)
        uri = URI.parse("https://graph.facebook.com/v2.10/#{sender_id}?fields=first_name,last_name,profile_pic,locale,gender,timezone&access_token=#{ENV['ACCESS_TOKEN']}")
        response = Net::HTTP.get_response(uri)
        data = JSON.parse(response.body)
        
        user = User.create(sender_id: sender_id, first_name: data["first_name"], last_name: data["last_name"], gender: data["gender"], locale: data["locale"], timezone: data["timezone"], profile_picture: data["profile_pic"], role: "user")
      end
      
      Send.attachment(sender_id, "https://i.giphy.com/26xBwdIuRJiAIqHwA.gif", "image")
      Send.bet(sender_id)
    end
    
    # CHECK IF USER EXISTS
    if User.find_by(:sender_id => sender_id)
    
    else
      
    end
    
  end
end
class Messenger::Attachment
  extend ActiveModel::Naming
  Send = MessengerController::Send.new
  
  def initialize(sender_id, text)
    
  end
end
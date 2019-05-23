class Messenger::QuickReply
  extend ActiveModel::Naming
  Send = MessengerController::Send.new
  
  def initialize(sender_id, quick_reply)
    
  end
end
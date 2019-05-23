class Messenger::Text
  extend ActiveModel::Naming
  Send = MessengerController::Send.new
  
  def initialize(sender_id, text)
    # CHECK IF USER EXISTS
    if User.find_by(:sender_id => sender_id)
      user = User.find_by(:sender_id => sender_id)
    
      if text.match('hello')
        Send.text_message(sender_id, "Hello #{user.first_name}")
      elsif text.match('play')
        Send.bet(sender_id)
        elsif text =~ /^hi/
          Send.new.text_message(sender_id, "Hey Hey! glad you stopped by.")
        elsif text =~ /^help/
          Send.text_message(sender_id, Rumoji.decode("Sure. If you look at the menu below :point_down: there are a few options. Choose one. "))
        elsif text =~ /^((how)( are|'re) (you|u|y))/
          Send.text_message(sender_id, Rumoji.decode("Never better. Ready to win some Fantasy :football: Games."))
        elsif text =~ /^((what)( are|'re) (you|u|y))/
          Send.text_message(sender_id, Rumoji.decode("Daily Fantasy Football :zap: w/ Friends. Draft a team by selecting players. Challenge a friend to do the same. The players on your team rack-up stats and earn points. The most points, wins. Add fun wagers like: :hamburger: Food, :beer: drinks, :computer: Social Media Posts, :joy: Cleaning your bathroom, or create your own fun wager. "))
          Send.bet(sender_id)
        elsif text =~ /^((what) (do) (you|u|y) (do))/
          Send.text_message(sender_id, Rumoji.decode("Help you create Fantasy Football Games :zap: w/ Friends. I can hook that up now, if you'd like :point_down:"))
          Send.bet(sender_id)
        elsif text =~ /^((who) (made) (you|u|y))/
          Send.text_message(sender_id, "I'd like to think I'm a self-made silicon. But, Cam Burley, and Libor Zahrádka might have had something to do with it, too.")
        elsif text =~ /^((how) (does) (this|it) (work))/
          Send.text_message(sender_id, "To get started, click the button below. Choose a game type, select your team, & invite a buddy. Done!")
          Send.bet(sender_id)
        elsif text =~ /^((why) (( would|'d) i use|use) (this|it))/
          Send.text_message(sender_id, Rumoji.decode("It\'s like regular fantasy but much faster. You\'re basically playing in the championship every week. No Credit Cards. No commissions. Just good fun with the homies :raised_hands:"))
        elsif text =~ /^((how) (easy) (is) (it|this))/
          Send.text_message(sender_id, Rumoji.decode("Too easy :point_down:"))
          Send.bet(sender_id)
        elsif text =~ /^((thank) (you|u|y)|thanks|thx)/
          Send.text_message(sender_id, Rumoji.decode("I should be thanking you! :pray: "))
        
      end
    else
      Send.get_started(sender_id)
    end
  end
  
end
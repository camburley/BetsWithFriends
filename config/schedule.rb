set :output, "/home/ubuntu/bet-messenger/log/cron.log"
set :bundle_command, "/home/ubuntu/.rvm/gems/ruby-2.4.0@my_gemset/bin/bundle exec"

every :day, :at => "12:00 pm" do
    runner "Bet.close_bets"
end

every 1.hour do
  runner "Bet.gamestart_alert"
end
require 'rest-client'

class MessengerController < ApplicationController
  protect_from_forgery with: :null_session
  layout false
    
  class Send
    def post_reply(text, comment_id)
      data = {
        message: text
      }
      
      url = URI.parse("https://graph.facebook.com/v2.10/#{comment_id}/comments?access_token=EAACFLosipWkBACYZCpmuX8eqSsWHUQZCJsY7NTfSxYbpOUelDBZCdD4Fqd4I2nNJRZAy2zsCRrzvkOmAJZCYsdnG7DJuoIl5olR5Jm8IMcfBvf53FraFpjvDEAzeiaFQXCFIgaHEpKLfDttrQV7CWLYHK6CEKH7wD7jnF0kYiRAZDZD")
      
      http = Net::HTTP.new(url.host, 443)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE #only for development.
      begin
        request = Net::HTTP::Post.new(url.request_uri)
        request["Content-Type"] = "application/json"
        request.body = data.to_json
        response = http.request(request)
        body = JSON(response.body)
        return { ret: body["error"].nil?, body: body }
      rescue => e
        raise e
      end
    end
    
    def send_message(data)
      url = URI.parse("https://graph.facebook.com/v2.10/me/messages?access_token=#{ENV['ACCESS_TOKEN']}")
    
      http = Net::HTTP.new(url.host, 443)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE #only for development.
      begin
        request = Net::HTTP::Post.new(url.request_uri)
        request["Content-Type"] = "application/json"
        request.body = data.to_json
        response = http.request(request)
        body = JSON(response.body)
        return { ret: body["error"].nil?, body: body }
      rescue => e
        raise e
      end
    end
    
    # SIMPLE MESSAGE
    def text_message(sender, text)
      data = {
        recipient: { id: sender},
        message: { text: text }
      }
      send_message(data)
    end
    
    # ATTACHMENT
    def attachment(sender, file, type)
      data = {
        recipient: { id: sender },
        message: { attachment: { type: type, payload: { url: file }} }
      }
      send_message(data)
    end
  
  # CUSTOM TEMPLATES
  # =======================
    
    def get_started(sender)
      data = {
        "recipient":{
          "id": sender
        },
        "message":{
          "attachment":{
            "type":"template",
            "payload":{
              "template_type":"button",
              "text": Rumoji.decode("Sorry, but you're not a user, to fix that click the button below."),
              "buttons":[
                {
                  "type":"postback",
                  "payload": "GET_STARTED_PAYLOAD",
                  "title":"Get started.."
                }
              ]
            }
          }
        }
      }
      
      send_message(data)
    end
    
    # BET
    def bet(sender)
      data = {
        "recipient":{
          "id": sender
        },
        "message":{
          "attachment":{
            "type":"template",
            "payload":{
              "template_type":"button",
              "text": Rumoji.decode("I'll help you start a game w/ friends."),
              "buttons":[
                {
                  "type":"web_url",
                  "url": "#{ENV['ROOT_PATH']}/bet/#{sender}",
                  "title":"Play New Game",
                  "webview_height_ratio": "full",
                  "messenger_extensions": true,
                  "fallback_url": "#{ENV['ROOT_PATH']}/bet/#{sender}"
                }
              ]
            }
          }
        }
      }
      
      send_message(data)
    end
    
    def bet_result(sender, text, bet_id)
      data = {
        "recipient":{
          "id": sender
        },
        "message":{
          "attachment":{
            "type":"template",
            "payload":{
              "template_type":"generic",
              "elements": [{
                "title": text,
                "image_url": "https://quant.chat/assets/winner-5ef5eeae11cc986b2fb69f7ae5e67bc43fdc89745e35efa9379c613206706c19.jpg",
                "subtitle": "See Results!",
                "buttons":[{
                    "type":"web_url",
                    "url":"#{ENV['ROOT_PATH']}/bet/result/#{bet_id}",
                    "title":"See the results",
                    "messenger_extensions": true,
                    "webview_height_ratio": "tall",
                    "fallback_url": "#{ENV['ROOT_PATH']}/bet/result/#{bet_id}"
                  }]
              }]
            }
          }
        }
      }
      
      send_message(data)
    end
    
    def game_notification(sender, image)
      data = {
        "recipient":{
          "id": sender
        },
        "message":{
          "attachment":{
            "type":"template",
            "payload":{
              "template_type":"generic",
              "elements": [{
                "title": Rumoji.decode("Your games are heating up :fire: Here's a quick game update:"),
                "image_url": image,
                "subtitle": "See Results!",
                "buttons":[{
                    "type":"web_url",
                    "url":"#{ENV['ROOT_PATH']}/get_user",
                    "title":"Check Score!",
                    "messenger_extensions": true,
                    "webview_height_ratio": "full",
                    "fallback_url": "#{ENV['ROOT_PATH']}/get_user"
                  }]
              }]
            }
          }
        }
      }
      
      send_message(data)
    end
    
  # ===========================
  # END CUSTOM TEMPLATES
  end
    
  def callback
    messaging_event = JSON.parse(request.body.read)
    
    if messaging_event["entry"].first["messaging"]
      # BEGIN Parsing JSON entry
      messaging_event["entry"].first["messaging"].each do |msg|
        sender_id = msg["sender"]["id"]
        
        # TYPE OF CONTENT 
        if msg["message"] && msg["message"]["text"]
          text = msg["message"]["text"].downcase
          Messenger::Text.new(sender_id, text) # TEXT MODEL
          
        elsif msg["postback"] && msg["postback"]["payload"]
          payload = msg["postback"]["payload"]
          Messenger::PostBack.new(sender_id, payload) # POSTBACK MODEL
        
        elsif msg["message"] && msg["message"]["quick_reply"]
          quick_reply = msg["message"]["quick_reply"]["payload"]
          Messenger::QuickReply.new(sender_id, quick_reply) # QUICK REPLY MODEL
        
        elsif msg["message"] && msg["message"]["attachments"]
        
        end
      
      end
    elsif messaging_event["entry"][0]["changes"] && messaging_event["entry"][0]["changes"][0]["field"] == "feed"
      
      messaging_event["entry"][0]["changes"].each do |msg|
        
        post_id = msg["value"]["post_id"]
        comment_id = msg["value"]["comment_id"]
        sender_name = msg["value"]["sender_name"]
        message = msg["value"]["message"].downcase if msg["value"]["message"]

        if message =~ /(#flashtips)/
          #create search variable 
          search = message.gsub(/^[^_]*(#flashtips( |))/, "")
          first_last = search[/^((?:\S+\s+){1}\S+)/]
          first = search[/^((?:\S+\s+){0}\S+)/]
          
          #create search results var 
          if Player.where("name ilike ?", "%#{first_last}%").any? && !first_last.nil?
            player = Player.where("name ilike ?", "%#{first_last}%").first
            unless player.prediction.empty? || player.prediction.nil?
              Send.new.post_reply(Rumoji.decode("🤖 #{player.name}, #{player.position}, projecting #{player.prediction[-1].values[-1]}pts vs #{player.opponent}"), comment_id)
            else
              Send.new.post_reply("Sorry but #{player.name} doesn't have any data yet...", comment_id)
            end
          elsif Player.where("name ilike ?", "%#{first}%").any? && !first.nil?
            player = Player.where("name ilike ?", "%#{first}%").first
            unless player.prediction.empty? || player.prediction.nil?
              Send.new.post_reply(Rumoji.decode("🤖 #{player.name}, #{player.position}, projecting #{player.prediction[-1].values[-1]}pts vs #{player.opponent}"), comment_id)
            else
              Send.new.post_reply("Sorry but #{player.name} doesn't have any data yet...", comment_id)
            end
          else
            Send.new.post_reply("Sorry but dunno that dude...", comment_id)
          end
        elsif message =~ /(#quiz)/
          message = message.gsub(/^[^_]*(#quiz( |))/, "")
          msg_re = message[/^((?:\S+\s+){1}\S+)/].nil? ? message[/^((?:\S+\s+){0}\S+)/] : message[/^((?:\S+\s+){1}\S+)/]
          
          if Post.find_by(:post_id => post_id)
            fb_post = Post.find_by(:post_id => post_id)
            if fb_post.answer.any? { |w| w.include? msg_re}
              result = fb_post.answer.each_with_index.select { |a, i| a =~ /#{msg_re}/}
              
              unless result.empty?
                value = result[0][1]
                unless fb_post.answer_taken.include? value
                  Send.new.post_reply("🤖 #{fb_post.message[value]}", comment_id)
                  
                  fb_post.winners << sender_name
                  fb_post.answer_taken << value
                  fb_post.save
                else
                  Send.new.post_reply("🤖 Correct, but someone answerd it already.", comment_id)
                end
              end
            else
              fb_response = Post.find_by(:post_id => post_id).i_message.empty? ? "Sorry... no dice!" : Post.find_by(:post_id => post_id).i_message.sample
              Send.new.post_reply("🤖 #{fb_response}", comment_id)
            end
          end
        end
      end
    end
  end
    
  def verify_callback
      challenge = params["hub.challenge"]
      verify_token = params["hub.verify_token"]
        
      if verify_token == ENV['VERIFY_TOKEN']
        render :json => challenge
      else
        redirect_to root_path
      end
  end
end

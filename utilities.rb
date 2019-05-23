Player.all.each do |pl|
    if Net::HTTP.get_response(URI.parse(pl.image)).code.to_i == 200
        pl.update_attributes(:image => "https://s3-us-west-2.amazonaws.com/static.fantasydata.com/headshots/nfl/low-res/#{pl.player_id}.png")
    else
        pl.update_attributes(:image => nil)     
    end
end

curl -X POST -H "Content-Type: application/json" -d '{
  "home_url" : {
     "url": "https://bet-messenger-dev-camburley.c9users.io/get_user",
     "webview_height_ratio": "tall",
     "webview_share_button": "show",
     "in_test":true
  }
}' "https://graph.facebook.com/v2.10/me/messenger_profile?access_token=EAAPiIfh8YK0BAGvE0ZA0EwcuTGkyALbbahZCZCuD2ucetGta7AB8MG6a2ZBrwYJBnerXsyn360H5UnJAqIjhADGPcXuZCHidgjiAvLppZCdWa7ZBkhMkZBNYZBNaeD70gdnsHqzXUFMdDt9sg28ptyxd4PhXdPYpusrv9y7NDOQbENuK7ArAZCB2Rr"

curl -X POST -H "Content-Type: application/json" -d '{
    "persistent_menu":[
        {
            "locale":"default",
            "composer_input_disabled": true,
            "call_to_actions":[
                {
                  "title":"Play New Game",
                  "type":"web_url",
                  "url":"https://bet-messenger-dev-camburley.c9users.io/get_user",
                  "webview_height_ratio":"full",
                  "messenger_extensions":true
                },
                {
                  "title":"Live Score",
                  "type":"web_url",
                  "url":"https://bet-messenger-dev-camburley.c9users.io/get_user?page=live",
                  "webview_height_ratio":"full",
                  "messenger_extensions":true
                },
                {
                    "title":"My Account",
                    "type":"nested",
                    "call_to_actions":[
                        {
                          "title":"All My Games",
                          "type":"web_url",
                          "url":"https://bet-messenger-dev-camburley.c9users.io/get_user?page=account",
                          "webview_height_ratio":"full",
                          "messenger_extensions":true
                        },
                        {
                          "title":"Leagues",
                          "type":"web_url",
                          "url":"https://bet-messenger-dev-camburley.c9users.io/get_user?page=leagues",
                          "webview_height_ratio":"full",
                          "messenger_extensions":true
                        }
                    ]
                }
            ]
        }
    ]
}' "https://graph.facebook.com/v2.10/me/messenger_profile?access_token=EAAPiIfh8YK0BAGvE0ZA0EwcuTGkyALbbahZCZCuD2ucetGta7AB8MG6a2ZBrwYJBnerXsyn360H5UnJAqIjhADGPcXuZCHidgjiAvLppZCdWa7ZBkhMkZBNYZBNaeD70gdnsHqzXUFMdDt9sg28ptyxd4PhXdPYpusrv9y7NDOQbENuK7ArAZCB2Rr"
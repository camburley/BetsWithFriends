class SessionsController < ApplicationController
    def create
        if auth
            unless Admin.find_by_fb_id(auth['uid'])
              admin = Admin.create_with_omniauth(auth)
              session[:admin_id] = admin.id
            else
              admin = Admin.find_by_fb_id(auth['uid'])
              session[:admin_id] = admin.id
            end
            
            redirect_to admin_path
        else
           redirect_to root_path 
        end
    end
    
    def destroy
        session[:admin_id] = nil
        redirect_to root_url
    end
    
    protected
        def auth
           request.env['omniauth.auth'] 
        end
end
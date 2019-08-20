require 'pundit'
class ApplicationController < Sinatra::Base
    include Pundit

    get '/' do
        erb :main
    end

    not_found do 
        status 404
        erb :oops
    end


    configure do
        set :views, 'app/views'
        set :public_folder, 'public'
        enable :sessions
        set :session_secret, SESSION_SECRET
        enable :logging
    end

    helpers do
        def logged_in?
            !!session[:user_id]
        end

        def current_user
            User.find_by(id: session[:user_id])
        end

        def authenticate
            if !logged_in?
                redirect '/login'
            end
        end
    end

end

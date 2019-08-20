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

        def h(text)
            Rack::Utils.escape_html(text)
        end

        def clean_params(params)
            cleaned_params = params.dup
            params.each do |k,v|
                cleaned_params[k] = h(v)
            end
            cleaned_params
        end
    end

end

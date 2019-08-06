class ApplicationController < Sinatra::Base

    get '/' do
        erb :index
    end

    configure do
        set :views, 'app/views'
        set :public_folder, 'public'
        enable :sessions
        set :session_secret, SESSION_SECRET
    end

end

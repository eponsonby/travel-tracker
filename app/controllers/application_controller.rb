class ApplicationController < Sinatra::Base

    get '/' do
        erb :test, layout: false
    end

    configure do
        set :views, 'app/views'
        set :public_folder, 'public'
    end

end

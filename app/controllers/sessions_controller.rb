class SessionsController < ApplicationController

    get '/home' do
        @trip = current_user.trips.all.sample
        erb :'sessions/home'
    end

    get '/login' do
        if logged_in?
            redirect '/trips'
        end
        @failed = false
        erb :'sessions/login'
    end

    post '/login' do
        user = User.find_by(username: params[:username])
        if !!user && user.authenticate(params[:password])
            session[:user_id] = user.id
            redirect '/trips'
        else
            @failed = true
            erb :'sessions/login'
        end
    end


    get '/signup' do
        if logged_in?
            redirect to '/home'
        end
        erb :'sessions/signup'
    end

    post '/signup' do
        @user = User.create(:username => params[:username], :email => params[:email], :password => params[:password])
        if @user.errors.any?
            erb :'sessions/signup'
        else
            session[:user_id] = @user.id
            redirect '/home'
        end
    end

    get '/logout' do
        if logged_in?
          session.clear
          redirect '/'
        else
          redirect to '/'
        end
    end

    get '/:user_id/trips' do
        @user = current_user
        erb :'sessions/show'
    end


end
class SessionsController < ApplicationController

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
            redirect to '/trips'
        end
        erb :'sessions/signup'
    end

    post '/signup' do
        @user = User.create(:first_name => params[:first_name], :last_name => params[:last_name], :username => params[:username], :email => params[:email], :password => params[:password])
        if @user.errors.any?
            erb :'sessions/signup'
        else
            session[:user_id] = @user.id
            redirect '/trips'
        end
    end

    get '/logout' do
        if logged_in?
          session.clear
          redirect '/login'
        else
          redirect to '/'
        end
    end


end
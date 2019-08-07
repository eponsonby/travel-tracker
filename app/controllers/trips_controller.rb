class TripsController < ApplicationController
    
    get '/trips' do
        authenticate
        @trips = Trip.all
        erb :'trips/index'
    end

    get '/trips/new' do
        authenticate
        erb :'trips/new'
    end

    post '/trips' do
        if params[:country].empty?
            redirect to '/trips/new'
          else
            trip = Trip.create(content: params[:content])
          end
          current_user.trips << trip
          current_user.save
          redirect to '/users/:user_id'


    get '/trips/:trip_id' do
        @trip = Trip.find_by(id: params[:trip_id])
        erb :'trips/show_trip'
    end

    delete '/trips/:trip_id' do
        @trip = Trip.find_by(id: params[:trip_id])
        if logged_in? && current_user.trips.include?(@trip)
          @trip.destroy
        else
          redirect '/login'
        end
    end
    


end
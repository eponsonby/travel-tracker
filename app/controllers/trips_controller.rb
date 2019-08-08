class TripsController < ApplicationController
    
    get '/trips' do
        authenticate
        @trips = Trip.all
        erb :'trips/index'
    end

    get '/trips/new' do
        authenticate
        @failed_date_visited = false
        @failed_country = false
        @failed_trip_title = false
        erb :'trips/new'
    end

    post '/trips' do
        if params[:category] == "Past Trip" && params[:date_visited].empty?
            @failed_date_visited = true
            erb :'/trips/new'
        elsif
            params[:country].empty?
                @failed_country = true
                erb :'trips/new'
            elsif
                params[:trip_title].empty?
                @failed_trip_title = true
                erb :'trips/new'
            else
                trip = Trip.create(trip_title: params[:trip_title], country: params[:country], city: params[:city], date_visited: params[:date_visited], category: params[:category])
                current_user.trips << trip
                current_user.save
                redirect to "/#{current_user.id}/trips"
        end

    end

    get '/trips/:trip_id' do
        @trip = Trip.find_by(id: params[:trip_id])
        @highlights = @trip.highlights
        erb :'trips/show_trip'
    end

    get '/trips/:trip_id/edit' do
        @trip = Trip.find_by(id: params[:trip_id])
        @failed_date_visited = false
        @failed_country = false
        @failed_trip_title = false
        erb :'trips/edit'
    end

    patch '/trips/:trip_id' do
        @trip = Trip.find_by(id: params[:trip_id])
        if params[:category] == "Past Trip" && params[:date_visited].empty?
            @failed_date_visited = true
            erb :'/trips/edit'
        elsif
            params[:country].empty?
                @failed_country = true
                erb :'trips/edit'
            elsif
                params[:trip_title].empty?
                @failed_trip_title = true
                erb :'trips/edit'
            else
                trip = Trip.find_by(id: params[:trip_id])
                trip.category = params[:category]
                trip.date_visited = params[:date_visited]
                trip.country = params[:country]
                trip.trip_title = params[:trip_title]
                trip.save
                redirect to "/#{current_user.id}/trips"
        end

    end


    delete '/trips/:trip_id' do
        @trip = Trip.find_by(id: params[:trip_id])
        if logged_in? && current_user.trips.include?(@trip)
          @trip.destroy
          redirect "/#{current_user.id}/trips"
        else
          redirect "/#{current_user.id}/trips"
        end
    end
    


end
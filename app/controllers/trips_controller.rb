class TripsController < ApplicationController
    
    get '/trips' do
        authenticate
        @trips = Trip.all
        erb :'trips/index'
    end

    get '/trips/new' do
        authenticate
        @failed_year_visited = false
        @failed_country = false
        @failed_trip_title = false
        erb :'trips/new'
    end

    post '/trips' do
        if params[:category] == "Past Trip" && params[:year_visited].empty?
            @failed_year_visited = true
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
                trip = Trip.create(trip_title: params[:trip_title], country: params[:country], city: params[:city], year_visited: params[:year_visited], category: params[:category])
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
        @failed_year_visited = false
        @failed_country = false
        @failed_trip_title = false
        erb :'trips/edit'
    end

    patch '/trips/:trip_id' do
        @trip = Trip.find_by(id: params[:trip_id])
        if params[:category] == "Past Trip" && params[:year_visited].empty?
            @failed_year_visited = true
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
                trip.year_visited = params[:year_visited]
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
    
    get '/:user_id/trips/past-trips' do
        authenticate
        @trips = Trip.where(category: "Past Trip")
        @user_id = params[:user_id]
        @sort = params[:sort]
        if @sort == 'country'
            @trips = @trips.order(:country)
        elsif @sort == "year"
            @trips = @trips.order(:year_visited)
        elsif @sort == "year,desc"
            @trips = @trips.order('year_visited ASC').reverse_order
        elsif @sort == "city"
            @trips = @trips.order(:city)
        elsif @sort == "title"
            @trips = @trips.order(:trip_title)
        end 

        erb :'/trips/show_all_past_trips'
    end



end
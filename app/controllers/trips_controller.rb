class TripsController < ApplicationController

    get '/trips' do
        authenticate
        @user_id = params[:user_id]
        @sort = params[:sort]
        @status = params[:status]
        if @status == "pasttrips"
            @trips = current_user.trips.where("category = 'Past Trip'")
        elsif @status == "wishlist"
            @trips = current_user.trips.where("category = 'Wishlist'")
        else
            @trips = current_user.trips.all
        end
        
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

        erb :'/trips/show_all_trips'
    end   
    
    
    get '/trips/new' do
        authenticate
        @failed_year_visited = false
        @failed_trip_title = false
        @failed_country = false
        @failed_category = false
        erb :'trips/new'
    end

    post '/trips' do
        if params[:category] == "Past Trip" && params[:year_visited] == nil
            @failed_year_visited = true
            erb :'/trips/new'
        elsif
            params[:category] == nil
            @failed_category = true
            erb :'/trips/new'
        elsif
            params[:trip_title].empty?  
            @failed_trip_title = true
            erb :'trips/new'
        elsif
            params[:country] == nil
            @failed_country = true
            erb :'/trips/new'
        else
            trip = Trip.create(trip_title: params[:trip_title], country: params[:country], city: params[:city], year_visited: params[:year_visited], category: params[:category])
            current_user.trips << trip
            current_user.save
            redirect to "/trips"
        end

    end

    get '/trips/:trip_id' do
        @trip = Trip.find_by(id: params[:trip_id])
        @highlights = @trip.highlights
        erb :'trips/show_trip'
    end

    get '/trips/:trip_id/edit' do
        @trip = Trip.find_by(id: params[:trip_id])
        @highlights = @trip.highlights
        @failed_year_visited = false
        @failed_country = false
        @failed_trip_title = false
        erb :'trips/edit'
    end

    patch '/trips/:trip_id' do
        @trip = Trip.find_by(id: params[:trip_id])
        if params[:category] == "Past Trip" && params[:year_visited] == nil
            @failed_year_visited = true
            erb :'/trips/edit'
        elsif
            params[:country] == nil
                @failed_country = true
                erb :'trips/edit'
            elsif
                params[:trip_title].empty?
                @failed_trip_title = true
                erb :'trips/edit'
            elsif
                params[:category] == nil
                @failed_trip_type = true
                erb :'trips/edit'
            else
                trip = Trip.find_by(id: params[:trip_id])
                trip.category = params[:category]
                trip.year_visited = params[:year_visited]
                trip.country = params[:country]
                trip.city = params[:city]
                trip.trip_title = params[:trip_title]
                trip.save
                redirect '/trips'
            end

    end


    delete '/trips/:trip_id' do
        @trip = Trip.find_by(id: params[:trip_id])
        if logged_in? && current_user.trips.include?(@trip)
          @trip.destroy
          redirect "/trips"
        else
          redirect "/trips"
        end
    end
    



end
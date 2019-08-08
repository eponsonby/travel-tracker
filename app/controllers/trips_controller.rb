class TripsController < ApplicationController
    
    get '/trips' do
        authenticate
        @trips = Trip.all
        erb :'trips/index'
    end

    get '/trips/new' do
        authenticate
        @failed = false
        erb :'trips/new'
    end

    post '/trips' do
        binding.pry
        if params[:category] == "Past Trip" && params[:date_visited].empty?
            @failed = true
            erb :'/trips/new'
        end
        if params[:country].empty? || params[:trip_title].empty?
            @failed = true
            erb :'trips/new'
        else
            trip = Trip.create(trip_title: params[:trip_title], country: params[:country], city: params[:city], date_visited: params[:date_visited], category: params[:category])
            current_user.trips << trip
            current_user.save
            redirect to "/#{current_user.id}/trips"
        end

    end

    get '/trips/:trip_id/highlights/new' do
        authenticate
        @trip = Trip.find_by(id: params[:trip_id])
        erb :'/highlights/new'
    end

    post '/highlights' do
        trip = Trip.find_by(id: params[:trip_id])
        if params[:place].empty?
            #add in an error messsage
            redirect to "/trips/#{trip.id}/highlights/new"
        else
            highlight = Highlight.create(highlight_category: params[:highlight_category], place: params[:place], notes: params[:notes], trip_id: params[:trip_id])
            trip.highlights << highlight
            redirect to "/trips/#{trip.id}"
        end
    end

    get '/trips/:trip_id' do
        @trip = Trip.find_by(id: params[:trip_id])
        @highlights = @trip.highlights
        erb :'trips/show_trip'
    end

    get '/trips/:trip_id/edit' do
        @trip = Trip.find_by(id: params[:trip_id])
        erb :'trips/edit'
    end

    get '/trips/:trip_id/:highlight_id/edit' do
        @trip = Trip.find_by(id: params[:trip_id])
        @highlight = Highlight.find_by(id: params[:highlight_id])
        erb :'highlights/edit'
    end

    delete '/trips/:trip_id/:highlight_id' do
        @highlight = Highlight.find_by(id: params[:highlight_id])
        @trip = Trip.find_by(id: params[:trip_id])
        if logged_in? && @trip.highlights.include?(@highlight)
            @highlight.destroy
            redirect "/trips/#{@trip.id}"
        else
            redirect "/trips/#{@trip.id}"
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
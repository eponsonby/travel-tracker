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
        if params[:country].empty? || params[:trip_title].empty?
            #add in an error messsage
            redirect to '/trips/new'
        else
            trip = Trip.create(trip_title: params[:trip_title], country: params[:country], city: params[:city], date_visited: params[:date_visited], category: params[:category])
            highlight = Highlight.create(highlight_category: params[:highlight_category], place: params[:place], notes: params[:notes])
        end
        trip.highlights << highlight
        current_user.trips << trip
        current_user.save
        redirect to "/#{current_user.id}/trips"
    end

    get '/trips/:trip_id/highlights/new' do
        authenticate
        @trip = Trip.find_by(id: params[:trip_id])
        erb :'/highlights/new'
    end

    post '/highlights' do
        highlight = Highlight.create(highlight_category: params[:highlight_category], place: params[:place], notes: params[:notes], trip_id: params[:trip_id])
        trip = Trip.find_by(id: params[:trip_id])
        trip.highlights << highlight
        redirect to "/trips/#{trip.id}"
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
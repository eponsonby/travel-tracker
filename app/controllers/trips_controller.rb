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
        redirect to "/#{:user_id}/trips"
    end

    get '/trips/:trip_id' do
        @trip = Trip.find_by(id: params[:trip_id])
        erb :'trips/show_trip'
    end

    get '/trips/:trip_id/edit'

    delete '/trips/:trip_id' do
        @trip = Trip.find_by(id: params[:trip_id])
        if logged_in? && current_user.trips.include?(@trip)
          @trip.destroy
          redirect "/#{:user_id}/trips"
        else
          redirect "/#{:user_id}/trips"
        end
    end
    


end
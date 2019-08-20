class HighlightsController < ApplicationController

    get '/trips/:trip_id/highlights/new' do
        authenticate
        @failed_place = false
        @trip = Trip.find_by(id: params[:trip_id])
        begin
            authorize @trip, :view?
        rescue
            erb :not_authorized
        else
            erb :'/highlights/new'
        end
    end

    post '/highlights' do
        authenticate
        @trip = Trip.find_by(id: params[:trip_id])
        clean_params = clean_params(params)
        if clean_params[:place].empty?
            @failed_place = true
            erb :'/highlights/new'
        else
            highlight = Highlight.create(place: clean_params[:place], notes: params[:notes], trip_id: params[:trip_id])
            @trip.highlights << highlight
            redirect to "/trips/#{@trip.id}"
        end
    end

    get '/trips/:trip_id/:highlight_id/edit' do
        authenticate
        @trip = Trip.find_by(id: params[:trip_id])
        @highlight = Highlight.find_by(id: params[:highlight_id])
        @failed_place = false
        begin
            authorize @highlight, :edit?
        rescue
            erb :'not_authorized'
        else
            erb :'highlights/edit'
        end
    end

    patch '/trips/:trip_id/:highlight_id' do
        authenticate
        @trip = Trip.find_by(id: params[:trip_id])
        @highlight = Highlight.find_by(id: params[:highlight_id])
        if params[:place].empty?
            @failed_place = true
            erb :'highlights/edit'
        else
            @highlight.place = params[:place]
            @highlight.notes = params[:notes]
            @highlight.save
            redirect to "/trips/#{@trip.id}"
        end
    end


    delete '/trips/:trip_id/:highlight_id' do
        authenticate
        @highlight = Highlight.find_by(id: params[:highlight_id])
        @trip = Trip.find_by(id: params[:trip_id])
        if logged_in? && @trip.highlights.include?(@highlight)
            @highlight.destroy 
            redirect "/trips/#{@trip.id}"
        else
            redirect "/trips/#{@trip.id}"
        end
    end
end
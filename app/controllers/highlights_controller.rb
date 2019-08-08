class HighlightsController < ApplicationController

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

    get '/trips/:trip_id/:highlight_id/edit' do
        @trip = Trip.find_by(id: params[:trip_id])
        @highlight = Highlight.find_by(id: params[:highlight_id])
        @failed_place = false
        erb :'highlights/edit'
    end

    patch '/trips/:trip_id/:highlight_id' do
        @trip = Trip.find_by(id: params[:trip_id])
        @highlight = Highlight.find_by(id: params[:highlight_id])

        if params[:place].empty?
            @failed_place = true
            erb :'highlights/edit'
        else
            @trip.category = params[:category]
            @trip.date_visited = params[:date_visited]
            @trip.country = params[:country]
            @trip.trip_title = params[:trip_title]
            @trip.save
            redirect "/trips/#{@trip.id}"
        end
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
end
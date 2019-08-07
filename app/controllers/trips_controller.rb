class TripsController < ApplicationController
    
    get '/trips' do
        authenticate
        @trips = Trip.all
        erb :'trips/index'
    end

end
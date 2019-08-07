class TripsController < ApplicationController
    
    get '/trips' do
        authenticate
        erb :'trips/index'
    end

end
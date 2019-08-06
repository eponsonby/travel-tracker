class User < ActiveRecord::Base
    has_many :trips
    has_many :trip_highlights, through: :trips
end


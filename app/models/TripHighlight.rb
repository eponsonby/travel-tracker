class TripHighlight < ActiveRecord::Base
    belongs_to :trip
    belongs_to :highlight
end

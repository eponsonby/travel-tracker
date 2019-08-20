class TripPolicy
    attr_reader :user, :trip

    def initialize(user, trip)
        @user = user
        @trip = trip
    end

    def edit?
        trip.user_id == user.id
    end

    def view?
        trip.user_id == user.id
    end
end

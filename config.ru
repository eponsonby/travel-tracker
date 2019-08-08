require_relative './config/env'

use Rack::MethodOverride
use HighlightsController
use TripsController
use SessionsController
run ApplicationController
require_relative './config/env'

use Rack::MethodOverride
use TripsController
use SessionsController
run ApplicationController
require_relative './config/env'

use Rack::MethodOverride
use SessionsController
run ApplicationController
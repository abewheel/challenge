require_relative './config/environment'

# This allows us to auto-scale on Heroku.
# use RailsAutoscaleAgent::Middleware

# Sinatra pieces
use API::GeoController

# Ready to roll!
run ApplicationController
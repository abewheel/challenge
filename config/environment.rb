require 'bundler'
Bundler.require

# Disable stdout buffering to allow for realtime logging with Heroku.
$stdout.sync = true

# The default Rack environment is development.
ENV['RACK_ENV'] ||= 'development'

# This is where we keep our CA certs.
ENV['SSL_CERT_FILE'] ||= 'config/certs/cacerts.pem'

# Exclude root node containing object class type when JSON is emitted.
ActiveRecord::Base.include_root_in_json = false

# Log all SQL calls.
ActiveRecord::Base.logger = Logger.new(STDOUT) unless ENV['RACK_ENV'] == 'production'

# Set the ActiveRecord time zone to the [application] machine's time zone.
ActiveRecord::Base.default_timezone = :local

# Open database.yml and get the credentials for the given db.
dbconfig = YAML.load(ERB.new(File.read('./config/database.yml')).result)

# Make the ActiveRecord mysql connection.
ActiveRecord::Base.establish_connection dbconfig[ENV['RACK_ENV']]

# Set the time zone for Rails.
Time.zone = ENV['TZ'] || 'America/Los_Angeles'

require_all 'lib'
require_all 'app/controllers'
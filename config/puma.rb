workers Integer(ENV['WEB_CONCURRENCY'] || 1)
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

# preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 9292
environment ENV['RACK_ENV'] || 'development'

# This is here in case we want to just launch Sidekiq as part of launching the web server.
# on_worker_boot do
#   @sidekiq_pid ||= spawn('bundle exec sidekiq -r ./all.rb')
#   ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
# end
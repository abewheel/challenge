class ApplicationController < Sinatra::Base
  register Sinatra::Flash
  set :show_exceptions, false
  
  SAFE_PATHS = [
    '/', '/login', '/logout', '/ping', '/public', 
    '/api/geo', '/api/ips'
  ]

  configure do
    # Application environment
    env = case ENV['RACK_ENV']
    when 'development'
      :development
    else
      :production
    end

    # Sessions
    enable :sessions
    set :session_secret, "th3r3rn0s3cr3t5"
  end

  before do
    puts "\n#####\n#{request.request_method} #{request.path}, #{params.inspect}, BODY: #{request.body.read}"
    $stdout.flush

    # Authenticate the caller.
    puts "~ #{session.inspect}"
    @user = authenticate!
  end

  get '/login' do
    respond({ error: session[:message] || 'Please log in' })
  end

  get '/ping' do
    respond({ application: 'GeoIP API Tester', version: '0.0.1'})    
  end

  # Trap all internal errors.
  error 403 do
    respond({ error: response.body[0] })
  end

  error 500 do
    respond({ error: response.body[0] })
  end

  # Not found catch.
  not_found do
    respond({ error: '404 Not Found'})
  end

  error do
    respond({ error: "Something went wrong." })
  end

  helpers do
    def authenticate!
      if params[:api_key]
        session.clear
        user = User.find_by(api_key: params[:api_key])
      elsif session[:user_id]
        user = User.find_by(id: session[:user_id])
      end

      unless user
        unless SAFE_PATHS.include?(request.path)
          session[:attempted_path] = request.path_info
          session[:message] ||= "Please log in."
          redirect '/login'
        end
      end

      user
    end

    def respond(results)
      content_type :json
      JSON.generate(results.as_json)
    end

  end
end

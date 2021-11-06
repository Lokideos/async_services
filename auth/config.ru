require_relative 'config/environment'

# Rack Middlewares
if ENV["RACK_ENV"] == "development"
  use Rack::Cors do
    allow do
      origins '*'
      resource '/api/*', headers: :any, methods: :any
    end
  end
end

# Application startup
if ENV["RACK_ENV"] == "development"
  run lambda { |env|
    ApplicationLoader.reload_app!
    Application.call(env)
  }
else
  run Application.freeze.app
end

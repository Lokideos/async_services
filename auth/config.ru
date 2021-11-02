require_relative 'config/environment'

if ENV["RACK_ENV"] == "development"
  run lambda { |env|
    ApplicationLoader.reload_app!
    Application.call(env)
  }
else
  run Application.freeze.app
end

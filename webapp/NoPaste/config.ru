$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
require ::File.expand_path('../app.rb', __FILE__)

run Sinatra::Application

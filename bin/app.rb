require 'sinatra'
require './lib/random-sims/random.rb'

set :port, 8080
set :static, true
set :public_folder, 'static'
set :views, 'views'
enable :sessions
set :session_secret, 'BADSECRET'

get '/' do
  @sims = Randomiser.generate_sims

  erb :random, locals: { n: 0 }
end

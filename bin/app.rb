require 'sinatra'
require './lib/random-sims/random.rb'

set :port, 8080
set :views, 'views'
set :public, 'public'
set :static, true

get '/' do
  @sims = Randomiser.generate_sims

  erb :random, locals: { n: 0 }
end

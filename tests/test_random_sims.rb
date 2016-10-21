require './bin/app.rb'
require 'test/unit'
require 'rack/test'

# App tests. Made some changes here as I amended the form
class MyAppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_game_form
    get '/path'
    assert last_response.ok?
    assert last_response.body.include?('something')
  end
end

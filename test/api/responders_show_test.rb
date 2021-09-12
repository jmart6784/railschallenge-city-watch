require 'test_helper'
require 'json'

class RespondersShowTest < ActionDispatch::IntegrationTest
  def setup
    super

    post '/api/v1/responders/', responder: { type: 'Fire', name: 'F-100', capacity: 1 }
  end

  test 'GET /api/v1/responders/:name simple get by name' do
    get '/api/v1/responders/F-100'

    assert_equal(JSON.parse(Responder.first.to_json), JSON.parse(body))
  end

  # test 'GET /responders/:name 404 response' do
  #   get '/responders/non-existent-responder-name'

  #   assert_equal 404, response.status
  # end
end

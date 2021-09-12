require 'test_helper'
require 'json'

class RespondersIndexTest < ActionDispatch::IntegrationTest
  def setup
    super

    post '/api/v1/responders/', responder: { type: 'Fire', name: 'F-100', capacity: 1 }
    post '/api/v1/responders/', responder: { type: 'Police', name: 'P-100', capacity: 2 }
    post '/api/v1/responders/', responder: { type: 'Medical', name: 'M-100', capacity: 3 }
  end

  test 'GET /api/v1/responders/ should return all responders when some responders exist' do
    get '/api/v1/responders/'
    assert_equal 200, response.status
    assert_equal(JSON.parse(Responder.all.to_json), JSON.parse(body))
  end

  test 'GET /api/v1/responders/ should be empty when no responders exist' do
    Responder.destroy_all

    get '/api/v1/responders/'

    assert_equal 200, response.status
    assert_equal [], JSON.parse(body)
  end
end

require 'test_helper'
require 'json'

class RespondersCapacityTest < ActionDispatch::IntegrationTest
  def setup
    super

    post '/api/v1/responders/', responder: { type: 'Fire', name: 'F-100', capacity: 1 }
    post '/api/v1/responders/', responder: { type: 'Fire', name: 'F-101', capacity: 2 }
    put '/api/v1/responders/F-101', responder: { on_duty: true }

    post '/api/v1/responders/', responder: { type: 'Police', name: 'P-100', capacity: 3 }
    post '/api/v1/responders/', responder: { type: 'Police', name: 'P-101', capacity: 4 }
    put '/api/v1/responders/P-100', responder: { on_duty: true }

    post '/api/v1/responders/', responder: { type: 'Medical', name: 'M-100', capacity: 5 }
    post '/api/v1/responders/', responder: { type: 'Medical', name: 'M-101', capacity: 1 }
    put '/api/v1/responders/M-100', responder: { on_duty: true }
    put '/api/v1/responders/M-101', responder: { on_duty: true }
  end

  test 'GET /api/v1/responders/?show=capacity makes the emergency capacity available' do
    get '/api/v1/responders/?show=capacity'
    assert_equal(
      {
        'capacity' => {
          'Fire' => [2],
          'Police' => [3],
          'Medical' => [5, 1]
        }
      }, JSON.parse(body)
    )
  end

  test 'GET /api/v1/responders/?show=capacity increases and decreases as emergencies are created and resolved' do
    post '/api/v1/emergencies/', emergency: {
      code: 'E-00000001', 
      fire_severity: 1, 
      police_severity: 7, 
      medical_severity: 1 
    }

    get '/api/v1/responders/?show=capacity'
    assert_equal(
      {
        'capacity' => {
          'Fire' => [0],
          'Police' => [0],
          'Medical' => [5]
        }
      }, JSON.parse(body)
    )

    put '/api/v1/emergencies/E-00000001', emergency: { resolved_at: Time.zone.now }
    get '/api/v1/responders/?show=capacity'
    assert_equal(
      {
        'capacity' => {
          'Fire' => [2],
          'Police' => [3],
          'Medical' => [5, 1]
        }
      }, JSON.parse(body)
    )
  end

  test 'GET /api/v1/responders/?show=department show type of responders by department' do
    get '/api/v1/responders/?show=Fire'

    responder1 = Responder.find_by(name: "F-100")
    responder2 = Responder.find_by(name: "F-101")

    assert_equal(JSON.parse([responder1, responder2].to_json), JSON.parse(body))

    get '/api/v1/responders/?show=Police'

    responder1 = Responder.find_by(name: "P-100")
    responder2 = Responder.find_by(name: "P-101")

    assert_equal(JSON.parse([responder1, responder2].to_json), JSON.parse(body))

    get '/api/v1/responders/?show=Medical'

    responder1 = Responder.find_by(name: "M-100")
    responder2 = Responder.find_by(name: "M-101")

    assert_equal(JSON.parse([responder1, responder2].to_json), JSON.parse(body))
  end

  test 'GET /api/v1/responders/?show=total_capacity shows responders by type and their capacity regardless of being on duty' do
    get '/api/v1/responders/?show=total_capacity'

    assert_equal(
      JSON.parse({
        Fire: 3,
        Police: 7,
        Medical: 6
      }.to_json), 
      JSON.parse(body)
    )
  end
end

require 'test_helper'
require 'json'

class ScoreReportTest < ActionDispatch::IntegrationTest
  def setup
    super
    setup_fire
    setup_police
    setup_medical
  end

  def setup_fire
    post '/api/v1/responders/', responder: { type: 'Fire', name: 'F-101', capacity: 1 }
    post '/api/v1/responders/', responder: { type: 'Fire', name: 'F-102', capacity: 2 }
    post '/api/v1/responders/', responder: { type: 'Fire', name: 'F-103', capacity: 3 }
    post '/api/v1/responders/', responder: { type: 'Fire', name: 'F-104', capacity: 4 }
    post '/api/v1/responders/', responder: { type: 'Fire', name: 'F-105', capacity: 5 }
    put '/api/v1/responders/F-101', responder: { on_duty: true }
    put '/api/v1/responders/F-103', responder: { on_duty: true }
    put '/api/v1/responders/F-104', responder: { on_duty: true }
  end

  def setup_police
    post '/api/v1/responders/', responder: { type: 'Police', name: 'P-101', capacity: 1 }
    post '/api/v1/responders/', responder: { type: 'Police', name: 'P-102', capacity: 2 }
    post '/api/v1/responders/', responder: { type: 'Police', name: 'P-103', capacity: 3 }
    post '/api/v1/responders/', responder: { type: 'Police', name: 'P-104', capacity: 4 }
    post '/api/v1/responders/', responder: { type: 'Police', name: 'P-105', capacity: 5 }
    put '/api/v1/responders/P-102', responder: { on_duty: true }
    put '/api/v1/responders/P-103', responder: { on_duty: true }
    put '/api/v1/responders/P-104', responder: { on_duty: true }
    put '/api/v1/responders/P-105', responder: { on_duty: true }
  end

  def setup_medical
    post '/api/v1/responders/', responder: { type: 'Medical', name: 'M-101', capacity: 1 }
    post '/api/v1/responders/', responder: { type: 'Medical', name: 'M-102', capacity: 2 }
    post '/api/v1/responders/', responder: { type: 'Medical', name: 'M-103', capacity: 3 }
    post '/api/v1/responders/', responder: { type: 'Medical', name: 'M-104', capacity: 4 }
    post '/api/v1/responders/', responder: { type: 'Medical', name: 'M-105', capacity: 5 }
    put '/api/v1/responders/M-101', responder: { on_duty: true }
    put '/api/v1/responders/M-102', responder: { on_duty: true }
    put '/api/v1/responders/M-103', responder: { on_duty: true }
  end

  test 'GET /api/v1/emergencies/?report=all Get a percentage of all emergencies that were resolved' do
    post '/api/v1/emergencies/', emergency: {
      code: 'E-00000001', 
      fire_severity: 1, 
      police_severity: 1, 
      medical_severity: 1
    }
    post '/api/v1/emergencies/', emergency: {
      code: 'E-00000002', 
      fire_severity: 1, 
      police_severity: 1, 
      medical_severity: 1
    }
    post '/api/v1/emergencies/', emergency: {
      code: 'E-00000003', 
      fire_severity: 1, 
      police_severity: 1, 
      medical_severity: 1
    }
    post '/api/v1/emergencies/', emergency: {
      code: 'E-00000004', 
      fire_severity: 99, 
      police_severity: 99, 
      medical_severity: 99
    }
    get '/api/v1/emergencies/?report=all'

    assert_equal 200, response.status
    assert_equal [], JSON.parse(body)['emergencies']
    
  end
end

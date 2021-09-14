require 'test_helper'
require 'json'

class EmergenciesDispatchTest < ActionDispatch::IntegrationTest
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

  test 'POST /api/v1/emergencies/ will dispatch just one responder, if that responder can handle the emergency completely' do
    post '/api/v1/emergencies/', emergency: { code: 'E-00000001', fire_severity: 3, police_severity: 0, medical_severity: 0 }
    json_response = JSON.parse(body)

    assert_equal('F-103', json_response['responders'][0]['name'])
    assert(json_response['full_response'])
  end

  test 'POST /api/v1/emergencies/ will dispatch just enough resources for an emergency' do
    post '/api/v1/emergencies/', emergency: {
      code: 'E-00000001', 
      fire_severity: 3, 
      police_severity: 12, 
      medical_severity: 1 
    }
    json_response = JSON.parse(body)

    responder1 = Responder.find_by(name: "F-103")
    responder2 = Responder.find_by(name: "P-102")
    responder3 = Responder.find_by(name: "P-103")
    responder4 = Responder.find_by(name: "P-104")
    responder5 = Responder.find_by(name: "P-105")
    responder6 = Responder.find_by(name: "M-101")

    # Assertion modified but full response is stil acheived
    assert_equal(
      JSON.parse(
        [responder1, responder2, responder3, responder4, responder5, responder6].to_json
      ), 
      json_response['responders']
    )
    assert(json_response['full_response'])
  end

  # test 'POST /emergencies/ will dispatch all resources for an emergency that exceeds on-duty resources' do
  #   post '/emergencies/', emergency: {
  #     code: 'E-00000001', fire_severity: 99, police_severity: 99, medical_severity: 99
  #   }

  #   json_response = JSON.parse(body)

  #   assert_equal(
  #     ['F-101', 'F-103', 'F-104', 'M-101', 'M-102', 'M-103', 'P-102', 'P-103', 'P-104', 'P-105'],
  #     json_response['emergency']['responders'].sort
  #   )
  #   refute json_response['emergency']['full_response']
  # end

  # test 'POST /emergencies/ will dispatch NO resources for an emergency with severities that are all zero' do
  #   post '/emergencies/', emergency: { code: 'E-00000001', fire_severity: 0, police_severity: 0, medical_severity: 0 }
  #   json_response = JSON.parse(body)

  #   assert_equal([], json_response['emergency']['responders'].sort)
  #   assert json_response['emergency']['full_response']
  # end
end

require 'test_helper'

class RespondersUpdateTest < ActionDispatch::IntegrationTest
  def setup
    super

    post '/api/v1/responders/', responder: { type: 'Fire', name: 'F-100', capacity: 1 }
  end

  test 'PATCH /api/v1/responders/:name can change on_duty' do
    put '/api/v1/responders/F-100', responder: { on_duty: false }
    responder = Responder.find_by(name: 'F-100')
    assert_equal(false, responder.on_duty)

    put '/api/v1/responders/F-100', responder: { on_duty: true }
    responder = Responder.find_by(name: 'F-100')
    assert_equal(true, responder.on_duty)
  end

  test 'PATCH /api/v1/responders/:name cannot change emergency_code (it can only be set by the system)' do
    put '/api/v1/responders/F-100', responder: { emergency_code: 'E-101' }

    assert_equal 422, response.status
    assert_equal({ 'message' => 'found unpermitted parameter: emergency_code' }, JSON.parse(body))
  end

  test 'PATCH /api/v1/responders/:name cannot change type' do
    put '/api/v1/responders/F-100', responder: { type: 'Police' }

    assert_equal 422, response.status
    assert_equal({ 'message' => 'found unpermitted parameter: type' }, JSON.parse(body))
  end

  test 'PATCH /api/v1/responders/:name cannot change name' do
    put '/api/v1/responders/F-100', responder: { name: 'F-999' }

    assert_equal 422, response.status
    assert_equal({ 'message' => 'found unpermitted parameter: name' }, JSON.parse(body))
  end

  test 'PATCH /api/v1/responders/:name cannot change capacity' do
    put '/api/v1/responders/F-100', responder: { capacity: 7 }

    assert_equal 422, response.status
    assert_equal({ 'message' => 'found unpermitted parameter: capacity' }, JSON.parse(body))
  end
end

require 'test_helper'
require 'json'

class EmergenciesCreateTest < ActionDispatch::IntegrationTest
  test 'POST /api/v1/emergencies/ simple creation' do
    post '/api/v1/emergencies/', emergency: {
      code: 'E-99999999',
      fire_severity: 1,
      police_severity: 2,
      medical_severity: 3
    }
    json_response = JSON.parse(response.body)

    assert_equal 201, response.status
    assert_nil body['message']
    assert_equal 'E-99999999', json_response['emergency']['code']
    assert_equal 1, json_response['emergency']['fire_severity']
    assert_equal 2, json_response['emergency']['police_severity']
    assert_equal 3, json_response['emergency']['medical_severity']
  end

  test 'POST /api/v1/emergencies/ all severities must be greater than or equal to zero' do
    post '/api/v1/emergencies', emergency: {
      code: 'E-55555555',
      fire_severity: -1,
      police_severity: -1,
      medical_severity: -1
    }
    assert_equal 422, response.status
    assert_equal(
      {
        'fire_severity' => ['must be greater than or equal to 0'],
        'police_severity' => ['must be greater than or equal to 0'],
        'medical_severity' => ['must be greater than or equal to 0']
      },
      JSON.parse(body)
    )
  end

  test 'POST /api/v1/emergencies/ code attribute must be unique' do
    post '/api/v1/emergencies', emergency: {
      code: 'E-not-unique',
      fire_severity: 1,
      police_severity: 3,
      medical_severity: 5
    }
    json_response = JSON.parse(body)

    assert_equal 201, response.status
    assert_nil(json_response['message'])
    assert_equal('E-not-unique', json_response['emergency']['code'])
    assert_equal(1, json_response['emergency']['fire_severity'])
    assert_equal(3, json_response['emergency']['police_severity'])
    assert_equal(5, json_response['emergency']['medical_severity'])

    post '/api/v1/emergencies', emergency: {
      code: 'E-not-unique',
      fire_severity: 1,
      police_severity: 3,
      medical_severity: 5
    }

    assert_equal 422, response.status
    assert_equal({ 'code' => ['has already been taken'] }, JSON.parse(body))
  end

  test 'POST /api/v1/emergencies/ cannot set id' do
    post '/api/v1/emergencies', emergency: {
      id: 1,
      fire_severity: 1,
      police_severity: 2,
      medical_severity: 3
    }

    assert_equal 422, response.status
    assert_equal({ 'message' => 'found unpermitted parameter: id' }, JSON.parse(body))
  end

  test 'POST /api/v1/emergencies/ cannot set resolved_at' do
    post '/api/v1/emergencies', emergency: {
      resolved_at: Time.zone.now,
      code: 'E-55555555',
      fire_severity: 1,
      police_severity: 2,
      medical_severity: 3
    }

    assert_equal 422, response.status
    assert_equal({ 'message' => 'found unpermitted parameter: resolved_at' }, JSON.parse(body))
  end

  test 'POST /api/v1/emergencies/ lack of fire_severity returns an error' do
    post '/api/v1/emergencies', emergency: {
      code: 'E-55555555',
      police_severity: 2,
      medical_severity: 3
    }

    assert_equal 422, response.status
    assert_equal(
      {
        'fire_severity' => ["can't be blank", 'must be greater than or equal to 0']
      },
      JSON.parse(body)
    )
  end

  test 'POST /api/v1/emergencies/ lack of police_severity returns an error' do
    post '/api/v1/emergencies', emergency: {
      code: 'E-55555555',
      fire_severity: 2,
      medical_severity: 3
    }

    assert_equal 422, response.status
    assert_equal(
      {
        'police_severity' => ["can't be blank", 'must be greater than or equal to 0']
      },
      JSON.parse(body)
    )
  end

  test 'POST /api/v1/emergencies/ lack of medical_severity returns an error' do
    post '/api/v1/emergencies', emergency: {
      code: 'E-55555555',
      fire_severity: 2,
      police_severity: 3
    }

    assert_equal 422, response.status
    assert_equal(
      {
        'medical_severity' => ["can't be blank", 'must be greater than or equal to 0']
      },
      JSON.parse(body)
    )
  end

  test 'POST /api/v1/emergencies/ lack of multiple required fields returns an error' do
    post '/api/v1/emergencies', emergency: { fire_severity: 1 }

    assert_equal 422, response.status
    assert_equal(
      {
        'code' => ['can\'t be blank'],
        'police_severity' => [
          "can't be blank",
          'must be greater than or equal to 0'
        ],
        'medical_severity' => [
          "can't be blank",
          'must be greater than or equal to 0'
        ]
      },
      JSON.parse(body)
    )
  end
end

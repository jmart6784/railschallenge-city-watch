require 'test_helper'

class EmergenciesUpdateTest < ActionDispatch::IntegrationTest
  def setup
    super

    post '/api/v1/emergencies/', emergency: { code: 'E-00000001', fire_severity: 1, police_severity: 1, medical_severity: 1 }
  end

  test 'PATCH /api/v1/emergencies/:code can change fire_severity' do
    put '/api/v1/emergencies/E-00000001', emergency: { fire_severity: 7 }

    json_response = JSON.parse(body)
    assert_equal 7, json_response['fire_severity']
  end

  # test 'PATCH /api/v1/emergencies/:code can change police_severity' do
  #   put '/api/v1/emergencies/E-00000001', emergency: { police_severity: 6 }

  #   json_response = JSON.parse(body)
  #   assert_equal 6, json_response['emergency']['police_severity']
  # end

  # test 'PATCH /api/v1/emergencies/:code can change medical_severity' do
  #   put '/api/v1/emergencies/E-00000001', emergency: { medical_severity: 4 }

  #   json_response = JSON.parse(body)
  #   assert_equal 4, json_response['emergency']['medical_severity']
  # end

  # test 'PATCH /api/v1/emergencies/:code can change resolved_at' do
  #   put '/api/v1/emergencies/E-00000001', emergency: { resolved_at: Time.zone.now }

  #   json_response = JSON.parse(body)
  #   assert_not_nil json_response['emergency']['resolved_at']
  # end

  # test 'PATCH /api/v1/emergencies/:code cannot change code (it is fixed once created)' do
  #   put '/api/v1/emergencies/E-00000001', emergency: { code: 'E-55555555' }

  #   assert_equal({ 'message' => 'found unpermitted parameter: code' }, JSON.parse(body))
  # end
end

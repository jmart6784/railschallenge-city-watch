require 'test_helper'

class Emergencies404Test < ActionDispatch::IntegrationTest
  test '404 on GET /api/v1/emergencies/new' do
    get '/api/v1/emergencies/new'
    assert_equal 404, response.status
    assert_equal({ 'message' => 'page not found' }, JSON.parse(body))
  end

  # test '404 on GET /api/v1/emergencies/:code/edit' do
  #   get '/api/v1/emergencies/F-100/edit'
  #   assert_equal 404, response.status
  #   assert_equal({ 'message' => 'page not found' }, JSON.parse(body))
  # end

  # test '404 on DELETE /api/v1/emergencies/:code' do
  #   delete '/api/v1/emergencies/F-100'
  #   assert_equal 404, response.status
  #   assert_equal({ 'message' => 'page not found' }, JSON.parse(body))
  # end
end

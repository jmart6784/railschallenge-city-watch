require 'test_helper'

class Responders404Test < ActionDispatch::IntegrationTest
  test '404 on GET /api/v1/responders/new' do
    get '/api/v1/responders/new'
    assert_equal 404, response.status
    assert_equal({ 'message' => 'page not found' }, JSON.parse(body))
  end

  test '404 on GET /api/v1/responders/:name/edit' do
    get '/api/v1/responders/F-100/edit'
    assert_equal 404, response.status
    assert_equal({ 'message' => 'page not found' }, JSON.parse(body))
  end

  test '404 on DELETE /api/v1/responders/:name' do
    delete '/api/v1/responders/F-100'
    assert_equal 404, response.status
    assert_equal({ 'message' => 'page not found' }, JSON.parse(body))
  end
end

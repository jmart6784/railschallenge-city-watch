Rails.application.routes.draw do
  scope '/api' do
    scope '/v1' do
      scope '/responders' do
        get '/' => 'responders#index'
        post '/' => 'responders#create'
        scope '/:name' do
          get '/' => 'responders#show'
          put '/' => 'responders#update'
        end
      end
    end
  end
end

Rails.application.routes.draw do
  scope '/api' do
    scope '/v1' do
      scope '/responders' do
        get '/' => 'responders#index'
        post '/' => 'responders#create'
        get '/new' => 'responders#new'

        scope '/:name' do
          get '/' => 'responders#show'
          put '/' => 'responders#update'
          get '/edit' => 'responders#edit'
          delete '/' => 'responders#destroy'
        end
      end

      scope '/emergencies' do
        get '/' => 'emergencies#index'
        post '/' => 'emergencies#create'
        get '/new' => 'emergencies#new'

        scope '/:code' do
          get '/' => 'emergencies#show'
          put '/' => 'emergencies#update'
          get '/edit' => 'emergencies#edit'
          delete '/' => 'emergencies#destroy'
        end
      end
    end
  end
end

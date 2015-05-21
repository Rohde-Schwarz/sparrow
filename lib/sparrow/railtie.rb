module Sparrow
  class Railtie < Rails::Railtie
    initializer 'sparrow.insert_middleware' do |app|
      # handle request
      app.config.middleware.insert_after 'Rails::Rack::Logger',
                                          'Sparrow::RequestMiddleware'
      # handle response
      app.config.middleware.use 'Sparrow::ResponseMiddleware'
    end
  end
end

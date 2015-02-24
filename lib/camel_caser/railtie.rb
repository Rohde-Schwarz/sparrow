module CamelCaser
  class Railtie < Rails::Railtie
    initializer 'camel_caser.insert_middleware' do |app|
      # handle request
      app.config.middleware.insert_after 'ActiveRecord::QueryCache',
                                          'CamelCaser::RequestMiddleware'
      # handle response
      app.config.middleware.use 'CamelCaser::ResponseMiddleware'
    end
  end
end

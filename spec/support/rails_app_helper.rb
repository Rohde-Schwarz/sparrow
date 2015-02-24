ENV["RAILS_ENV"] ||= "test"

#require File.expand_path("../../apps/rails_app/config/environment.rb",  __FILE__)
module RailsAppHelper
  include Rack::Test::Methods

  def app
    Rack::Builder.parse_file(config_ru_path).first
  end

  private
  def config_ru_path
    File.expand_path(File.join(File.dirname(__FILE__),
                               '..',
                               'integration',
                               'apps',
                               'rails_app',
                               'config.ru'))

  end
end

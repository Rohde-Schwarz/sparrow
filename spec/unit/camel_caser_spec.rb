require 'spec_helper'

describe CamelCaser do
  describe 'configuration' do
    it 'should return a Configuration object' do
      expect(CamelCaser.configuration).to(
          be_an_instance_of(CamelCaser::Configuration))
    end
  end

  describe 'configure' do
    it 'should yield the configuration and save it' do
      CamelCaser.configure do |configuration|
        configuration.json_request_format_header = 'panda'
        configuration.excluded_routes = ['panda']
      end

      configuration = CamelCaser.configuration
      expect(configuration.json_request_format_header).to eq 'panda'
      expect(configuration.excluded_routes).to eq ['panda']
    end
  end
end

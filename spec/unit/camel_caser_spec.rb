require 'spec_helper'

describe Sparrow do
  describe 'configuration' do
    it 'should return a Configuration object' do
      expect(Sparrow.configuration).to(
          be_an_instance_of(Sparrow::Configuration))
    end
  end

  describe 'configure' do
    it 'should yield the configuration and save it' do
      Sparrow.configure do |configuration|
        configuration.json_request_format_header = 'panda'
        configuration.excluded_routes = ['panda']
      end

      configuration = Sparrow.configuration
      expect(configuration.json_request_format_header).to eq 'panda'
      expect(configuration.excluded_routes).to eq ['panda']
    end
  end
end

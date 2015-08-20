require 'spec_helper'

module Sparrow
  describe Steward, type: :unit do
    let(:env) do
      {
          'PATH_INFO'    => '/api/state',
          'rack.input'   => 'teststring',
          'CONTENT-TYPE' => 'application/json',
          'ACCEPT'       => 'application/json'
      }
    end
    let(:http_message) { HttpMessage.new(env) }
    let(:excluded_routes) { ['/api/model/certificates'] }
    let(:allowed_accepts) { ['application/json'] }
    let(:allowed_content_types) { ['application/json'] }
    subject(:steward) do
      Steward.new(http_message,
                  allowed_accepts:       allowed_accepts,
                  allowed_content_types: allowed_content_types,
                  excluded_routes:       excluded_routes)
    end

    it { is_expected.to have_processable_http_message }
    its(:http_message) { is_expected.to eq http_message }
    its(:route_parser) { is_expected.to be_present }
    its(:excluded_routes) { is_expected.to eq excluded_routes }
    its(:allowed_accepts) { is_expected.to eq allowed_accepts }
    its(:allowed_content_types) { is_expected.to eq allowed_content_types }
  end
end

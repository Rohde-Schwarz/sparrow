module Sparrow
  describe Steward, type: :unit do
    let(:env) do
      {
        'PATH_INFO' => '/api/state',
        'rack.input' => 'teststring',
        'CONTENT-TYPE' => 'application/json',
        'ACCEPT' => 'application/json'
      }
    end
    let(:request) { Request.new(env) }
    let(:excluded_routes) { ['/api/model/certificates'] }
    let(:content_type) { 'application/json; charset=utf-8' }
    let(:allowed_accepts) { ['application/json'] }
    let(:allowed_content_types) { ['application/json'] }
    subject(:steward) do
      Steward.new(request,
      allowed_accepts: allowed_accepts,
      allowed_content_types: allowed_content_types,
      content_type: content_type,
      excluded_routes: excluded_routes)
    end

    it { is_expected.to have_processable_request }
    its(:request) { is_expected.to eq request }
    its(:route_parser) { is_expected.to be_present }
    its(:excluded_routes) { is_expected.to eq excluded_routes }
    its(:allowed_accepts) { is_expected.to eq allowed_accepts }
    its(:allowed_content_types) { is_expected.to eq allowed_content_types }
    its(:content_type) { is_expected.to eq content_type }
  end
end

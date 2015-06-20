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
    subject(:steward) do
      Steward.new(request,
      allowed_accepts: ['application/json'],
      allowed_content_types: ['application/json'],
      content_type: 'application/json; charset=utf-8',
      excluded_routes: ['/api/model/certificates'])
    end

    it { is_expected.to have_processable_request }
  end
end

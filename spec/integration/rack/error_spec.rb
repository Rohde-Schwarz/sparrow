require 'spec_helper'

describe 'the reactions when encountering error status', type: :rack do
  context 'when encountering a server error' do
    let(:json) { { error_code: 507 } }

    before do
      json_string = MultiJson.dump(json)
      post '/error', json_string, {}
    end

    it 'delegates the error response without failing' do
      expect(last_response.status).to eq json[:error_code]
      expect(last_response.body).to be_present
    end
  end
end

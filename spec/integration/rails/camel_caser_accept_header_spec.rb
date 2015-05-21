require 'spec_helper'

describe "camel caser middleware for Rails", type: :rails do

  let(:json_object) do
    {
      userName: 'dsci',
      bar:      { lordFoo: 12 },
      "DE"      => 'german'
    }
  end
  let(:json) { MultiJson.dump(json_object) }

    context "camel caser middleware for Rails with accept header " do

      before do
        Sparrow.configure do |config|
          config.allowed_accepts = %w[foo/bar]
        end
      end

      after do
        Sparrow.configure do |config|
          config.allowed_accepts = [nil]
        end
      end


      it 'does not process the request if the accept header is not allowed' do

        post '/posts', json, { 'request-json-format'  => 'underscore',
                               'response-json-format' => 'underscore',
                               'CONTENT-TYPE'         => 'application/json',
                               'ACCEPT'               => 'text/html' }

        last_json = MultiJson.load(last_response.body)
        expect(last_json['keys']).to include('userName')
        expect(last_json['keys']).to include('bar')
        expect(last_json['keys']).to include('DE')
      end

      it 'does process the request if the accept header is allowed' do

        post '/posts', json, { 'request-json-format'  => 'underscore',
                               'response-json-format' => 'underscore',
                               'CONTENT-TYPE'         => 'application/json',
                               'ACCEPT'               => 'foo/bar, gate/protect' }

        last_json = MultiJson.load(last_response.body)
        expect(last_json['keys']).to include('user_name')
        expect(last_json['keys']).to include('de')
      end
    end

end

require 'spec_helper'

describe "camel caser middleware for Rails", type: :rails do

  let(:json_object) do
    {
        userName: 'dsci',
        bar:      {lordFoo: 12}
    }
  end
  let(:json) { MultiJson.dump(json_object) }

  context "accept header is given" do

    context 'path not excluded' do
      before do
        post '/posts', json, {'request-json-format'  => 'underscore',
                              'response-json-format' => 'underscore',
                              "CONTENT_TYPE" => 'application/json'}
      end

      subject { MultiJson.load(last_response.body) }

      it "converts lower camelcase to underscore params" do
        expect(last_response).to be_successful
        expect(subject).to have_key("keys")
        expect(subject["keys"]).to include("user_name")
        expect(subject["keys"]).to include("bar")
        expect(subject["keys"]).to include("lord_foo")
      end
    end

    context 'exlude paths' do
      before do
        get '/ignore', json_object, {'CONTENT-TYPE' => 'application/json',
                                     'request-json-format'  => 'underscore',
                     'response-json-format' => 'underscore'}
      end

      subject { MultiJson.load(last_response.body) }

      it 'should not touch the input keys and the response' do
        expect(subject).to have_key('camelCase')
        expect(subject).to have_key('snake_case')
        expect(subject).to have_key('keys')
        keys = subject['keys']
        %w(userName lordFoo bar).each do |key|
          expect(keys).to include(key)
        end
      end
    end
  end

  context "accept header is not given" do
    context 'convert input params' do
      before do
        post '/posts', json, {"CONTENT_TYPE" => 'application/json'}
      end

      subject do
        MultiJson.load(last_response.body)
      end


      it "did not convert lower camelcase to underscore params" do
        expect(subject).to have_key("keys")
        expect(subject["keys"]).to include("userName")
      end
    end

    context 'convert response output keys' do
      before do
        get '/welcome', json_object, {'CONTENT-TYPE' => 'application/json',
                                      'request-json-format'  => 'camelize',
                                      'response-json-format' => 'underscore'}
      end

      subject do
        MultiJson.load(last_response.body)
      end

      it 'underscores the response' do
        expect(subject).to_not have_key('fakeKey')
        expect(subject).to have_key('fake_key')
        expect(subject['fake_key']).to eq false
      end
    end

    context 'convert elements if root element is an array instead of hash' do
      before  { get '/array_of_elements' }
      subject { MultiJson.load(last_response.body) }

      it 'should return an array as root element' do
        expect(subject.class).to eq Array
        expect(subject.first).to_not have_key("fake_key")
        expect(subject.first).to have_key("fakeKey")
      end

    end
  end
end

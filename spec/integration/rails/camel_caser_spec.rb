require 'spec_helper'

describe "camel caser middleware for Rails", type: :rails do

  let(:json_object) do
    {
      userName: 'dsci',
      last_name: 'smith',
      bar:      { lordFüü: 12 },
      "DE"      => 'german',
    }
  end
  let(:json) { MultiJson.dump(json_object) }

  context "accept header is given" do

    context 'path not excluded' do
      before do
        post '/posts', json, { 'request-json-format'  => 'underscore',
                               'response-json-format' => 'underscore',
                               'CONTENT-TYPE'         => 'application/json' }
      end

      subject { MultiJson.load(last_response.body) }

      it "converts lower camelcase to underscore params" do
        expect(last_response).to be_successful
        expect(subject).to have_key("keys")
        expect(subject["keys"]).to include("user_name")
        expect(subject["keys"]).to include("bar")
        expect(subject["keys"]).to include("lord_füü")
      end
    end

    context 'exclude paths' do
      context 'ignored json in and out' do
        before do
          get '/ignore', json_object, { 'CONTENT-TYPE'         => 'application/json',
                                        'request-json-format'  => 'underscore',
                                        'response-json-format' => 'underscore' }
        end

        subject { MultiJson.load(last_response.body) }

        it 'should not touch the input keys and the response' do
          expect(subject).to have_key('camelCase')
          expect(subject).to have_key('snake_case')
          expect(subject).to have_key('keys')
          keys = subject['keys']
          %w(userName lordFüü bar).each do |key|
            expect(keys).to include(key)
          end
        end
      end

      context 'ignored json in and ignored text out' do
        before do
          get '/ignore/non_json_text_response', json_object,
            { 'CONTENT-TYPE'         => 'application/json',
              'request-json-format'  => 'underscore',
              'response-json-format' => 'underscore' }
        end

        subject { last_response }

        it { is_expected.to be_successful }

        it 'should answer with a KEY' do
          expect(subject.body).to match /BEGIN PUBLIC KEY/
        end

        it 'should not touch the keys' do
          expect(subject.body).to match /userName/
          expect(subject.body).to match /lordFüü/
          expect(subject.body).to match /bar/
          expect(subject.body).to match /last_name/
        end

        it 'should be content-type html' do
          expect(subject.header['Content-Type']).to match /text\/html/
        end
      end

      context 'convert json in and ignored text out' do
        before do
          get '/welcome/non_json_text_response', json_object,
            { 'CONTENT-TYPE'         => 'application/json',
              'request-json-format'  => 'underscore',
              'response-json-format' => 'underscore' }
        end

        subject { last_response }

        it { is_expected.to be_successful }

        it 'should answer with a KEY' do
          expect(last_response.body).to match /BEGIN PUBLIC KEY/
        end

        it 'should touch the keys' do
          expect(subject.body).to match /user_name/
          expect(subject.body).to match /lord_füü/
          expect(subject.body).to match /bar/
          expect(subject.body).to match /last_name/
        end

        it 'should be content-type html' do
          expect(last_response.header['Content-Type']).to match /text\/html/
        end
      end
    end

    context 'converts GET url parameters' do
      before do
        get '/upcase_first_name?userOptions[firstName]=susi',
            {},
            {
              'request-json-format' => 'underscore',
              'CONTENT-TYPE'        => 'application/json'
            }
      end
      subject { MultiJson.load(last_response.body) }

      it 'should return an array as root element' do
        expect(subject).to_not have_key("user_options")
        expect(subject).to have_key("userOptions")
        expect(subject["userOptions"]).to have_key("firstName")
        expect(subject["userOptions"]["firstName"]).to eq("SUSI")
      end
    end

  end

  context "accept header is not given" do
    context 'convert input params' do
      before do
        post '/posts', json, { "CONTENT_TYPE" => 'text/x-json' }
      end

      subject do
        MultiJson.load(last_response.body)
      end


      it "did not convert lower camelcase to underscore params" do
        expect(subject).to have_key("keys")
        expect(subject["keys"]).to include("userName")
      end

      it "did not convert all UPPERCASE words to underscore params" do
        expect(subject).to have_key("keys")
        expect(subject["keys"]).to include("DE")
      end

    end

    context 'convert response output keys' do
      before do
        get '/welcome', json_object, { 'CONTENT-TYPE'         => 'application/json',
                                       'request-json-format'  => 'camelize',
                                       'response-json-format' => 'underscore' }
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
      before do
        get '/array_of_elements', nil, {
                                  'CONTENT-TYPE' => 'application/json; charset=utf-8'
                                }
      end
      subject { MultiJson.load(last_response.body) }

      it 'should return an array as root element' do
        expect(subject.class).to eq Array
        expect(subject.first).to_not have_key("fake_key")
        expect(subject.first).to have_key("fakeKey")
      end

    end

    context 'reaction on error responses' do
      require 'action_controller/metal/exceptions'
      it 'lets Rails do its RoutingError when the url is not found' do
        expect do
          get '/not_found_url', {}, { 'CONTENT-TYPE' => 'application/json' }
        end.to raise_error ActionController::RoutingError
      end

      it 'does not touch the response if a server error gets triggered' do
        expect {
          get '/error', {}, { 'CONTENT-TYPE' => 'application/json' }
        }.to raise_error ZeroDivisionError
      end
    end

    describe 'the configuration of allowed content types' do
      it 'does not process requests and responses that have disallowed content types' do
        get '/welcome', json_object, { 'CONTENT_TYPE'        => 'text/html',
                                       'request-json-format' => 'underscore' }

        last_json = MultiJson.load(last_response.body)
        expect(last_json).to have_key 'fakeKey'
        expect(last_json).to have_key 'keys'
      end

      it 'processes nothing if content-types configured contains nil and content type is sent' do
        Sparrow.configure do |config|
          config.allowed_content_types = [nil]
        end

        post '/posts', json, { 'request-json-format'  => 'underscore',
                               'response-json-format' => 'underscore',
                               'CONTENT-TYPE'         => '' }

        last_json = MultiJson.load(last_response.body)
        expect(last_json['keys']).to include('userName')
        expect(last_json['keys']).to include('DE')
      end

      it 'processes everything if content-types configured contains nil and content-type is empty' do
        Sparrow.configure do |config|
          config.allowed_content_types = [nil]
        end

        post '/posts', json, { 'request-json-format'  => 'underscore',
                               'response-json-format' => 'underscore',
                               'CONTENT_TYPE'         => ''}

        last_json = MultiJson.load(last_response.body)
        expect(last_json['keys']).to include('user_name')
        expect(last_json['keys']).to include('bar')
        # at the moment the "let uppercase as it is"-option only works for
        # camelCase. This test implies that.
        expect(last_json['keys']).to include('de')
      end

      it 'processes everything if content-types configured contains nil and no content-type is sent' do
        Sparrow.configure do |config|
          config.allowed_content_types = [nil]
        end

        post '/posts', json, { 'request-json-format'  => 'underscore',
                               'response-json-format' => 'underscore',
                               'CONTENT_TYPE'         => ''}

        last_json = MultiJson.load(last_response.body)
        expect(last_json['keys']).to include('user_name')
        expect(last_json['keys']).to include('bar')
        # at the moment the "let uppercase as it is"-option only works for
        # camelCase. This test implies that.
        expect(last_json['keys']).to include('de')
      end
    end
  end
end

require 'spec_helper'

describe "camel caser middleware", type: :rack do
   
  let(:json) do 
    MultiJson.dump({userName: "dsci", bar:{ lordFoo: 12 }})
  end
  
  context "accept header is given" do 
    
    before do 
      post '/', json, {'request-json-format' => 'underscore',
                       'response-json-format' => 'underscore'}
    end
  
    subject do 
      MultiJson.load(last_response.body)
    end

    it "converts lower camelcase to underscore params" do 
      expect(subject).to have_key("keys")
      expect(subject["keys"]).to include("user_name")
      expect(subject["keys"]).to include("bar")
      expect(subject["keys"]).to include("lord_foo")
      expect(subject).to have_key 'fake_key'
    end
  end

  context "accept header is not given" do
    before do 
      post '/', json
    end

    subject do 
      MultiJson.load(last_response.body)
    end

  
    it "did not convert lower camelcase to underscore params" do 
      expect(subject).to have_key("keys")
      expect(subject["keys"]).to include("userName")
    end

    it 'converted the snake case fake key to camelCase' do
      expect(subject['fake_key']).to_not be_present
      expect(subject['fakeKey']).to eq true
    end
  end
end

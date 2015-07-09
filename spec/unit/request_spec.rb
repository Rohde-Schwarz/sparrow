module Sparrow
  describe Request, type: :unit do
    let(:env) do
      {
        'Content-Type' => 'application/json; charset=utf-8',
        'Accept'       => 'application/json',
        'PATH_INFO'    => '/api/status.json',
        'rack.input'   => '',
        'rack.request.form_hash' => {
          'panda' => 'bamboo'
        }
      }
    end
    subject(:request) { Request.new(env) }

    its(:path) { is_expected.to eq '/api/status.json' }
    its(:accept) { is_expected.to eq 'application/json' }
    it { is_expected.to be_form_hash }

    describe '#content_type' do
      it 'takes the content type until the ;' do
        expect(request.content_type).to eq 'application/json'
      end

      context 'without env' do
        let(:env) { {} }
        it 'allows an unset content type' do
          expect(request.content_type).to eq nil
        end
      end
    end

    it 'wraps the environment hash' do
      expect(request.env).to eq env
    end

    describe '#request' do
      it 'wraps the real request object' do
        expect(request.request).to be_present
      end

      context 'when in a Rails environment' do
        it 'wraps a ActionDispatch::Request object' do
          require 'rails'
          expect(request.request).to be_an_instance_of ::ActionDispatch::Request
        end
      end

      context 'when in a Rack environment' do
        before do
          # unload Rails
          Object.send(:remove_const, :Rails)
        end

        it 'wraps a Rack::Request object' do
          expect(request.request).to be_an_instance_of ::Rack::Request
        end
      end
    end

    it 'delegates all unknown methods to the wrapped request object' do
      # use params accessor as example
      expect(request.params).to be
    end
  end
end

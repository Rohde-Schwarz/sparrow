require 'spec_helper'

module CamelCaser
  describe PathNormalizer, type: :unit do
    let(:clazz) do
      Class.new do
        include PathNormalizer
      end
    end

    subject { clazz.new }

    describe '.normalize_path' do
      it 'should remove any starting slash from the path string' do
        expect(subject.normalize_path('/panda')).to eq 'panda'
      end

      it 'should not touch any strings that do not start with a slash' do
        expect(subject.normalize_path('panda')).to eq 'panda'
      end
    end
  end
end
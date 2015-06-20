require 'spec_helper'

describe Sparrow::Strategies::KeyTransformation::CamelizeKey do

  subject(:camelize_key_strategy) do
    Sparrow::Strategies::KeyTransformation::CamelizeKey.new
  end

  describe '#transform_key' do

    it 'should camelize its inputs (defaulting to lower case camelizing)' do
      output = camelize_key_strategy.transform_key('wireless_configuration')
      expect(output).to eq('wirelessConfiguration')
    end

    it 'should leave all_uppercase strings as they are' do
      output = camelize_key_strategy.transform_key('DE')
      expect(output).to eq('DE')
    end
  end
end

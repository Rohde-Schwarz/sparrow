require 'spec_helper'

describe CamelCaser::Strategies::CamelizeKey do

  subject { CamelCaser::Strategies::CamelizeKey.new }

  describe '#transform_key' do

    it 'should camelize it´s inputs (defaulting to lower case camelizing)' do
      output = subject.transform_key("wireless_configuration")
      expect(output).to eq("wirelessConfiguration")
    end

    it 'should leave all_uppercase strings as they are' do
      output = subject.transform_key("DE")
      expect(output).to eq("DE")
    end
  end
end

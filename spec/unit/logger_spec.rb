module Sparrow
  describe Logger, type: :unit do
    subject(:logger) { Logger.new(true) }
    it { is_expected.to be_enabled }
  end
end

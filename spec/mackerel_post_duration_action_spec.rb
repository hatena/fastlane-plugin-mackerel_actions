describe Fastlane::Actions::MackerelPostDurationAction do
end

describe Fastlane::Helper::MackerelPostDurationHelper do
  describe '#verify_time' do
    it 'Time type' do
      time = Time.at(0)
      expect(Fastlane::Helper::MackerelPostDurationHelper.verify_time(time)).to eq(0)
    end

    it 'Integer type' do
      integet_time = Time.now.to_i
      expect(Fastlane::Helper::MackerelPostDurationHelper.verify_time(integet_time)).to eq(integet_time)
    end

    it 'String type' do
      string_time = '2006/01/02 15:04:05 +0900'
      expect(Fastlane::Helper::MackerelPostDurationHelper.verify_time(string_time)).to eq(1_136_181_845)
    end

    it 'Unsupported type' do
      value = nil
      expect { Fastlane::Helper::MackerelPostDurationHelper.verify_time(value) }.to raise_error(FastlaneCore::Interface::FastlaneError)
    end
  end
end

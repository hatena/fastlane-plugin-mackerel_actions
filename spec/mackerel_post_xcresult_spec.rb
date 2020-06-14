describe Fastlane::Actions::MackerelPostXcresultAction do
end

describe Fastlane::Helper::MackerelPostXcresultHelper do
  before(:all) do
    require 'scan'
    options = FastlaneCore::Configuration.create(Scan::Options.available_options, {
      project: 'examples/app/app.xcodeproj',
      scheme: 'app',
      derived_data_path: 'examples/app/build',
      output_directory: 'examples/app/fastlane/test_output'
    })
    manager = Scan::Manager.new
    manager.work(options)

    @file = Dir["#{ENV['PWD']}/examples/app/build/**/Logs/Test/*.xcresult"].last
  end

  describe '#json_xcresult_report' do
    it 'xccov view --report --json' do
      expect(Fastlane::Helper::MackerelPostXcresultHelper.json_xcresult_report(@file)).to be_kind_of(Hash)
    end
  end

  describe '#summarize_xcresult_report' do
    it 'check type' do
      expect(Fastlane::Helper::MackerelPostXcresultHelper.summarize_xcresult_report(@file)).to be_kind_of(Array)
    end

    it 'check row Hash.keys' do
      Fastlane::Helper::MackerelPostXcresultHelper.summarize_xcresult_report(@file).each do |row|
        expect(row.keys).to eq(['target', 'lineCoverage'])
        expect(row['target']).to be_kind_of(String)
        expect(row['lineCoverage']).to be_kind_of(Numeric)
      end
    end
  end
end

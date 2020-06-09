module Fastlane
  module Helper
    class MackerelPostXcresultHelper
      def self.json_xcresult_report(file)
        require 'open3'
        require "json"

        UI.header("xccov view --report")

        UI.command("xcrun xccov view --report #{file} --json")
        stdout, stderr, = Open3.capture3('xcrun', 'xccov', 'view', '--report', file.to_s, '--json')

        UI.command_output("stderr: #{stderr}")

        JSON.parse(stdout)
      end

      def self.summarize_xcresult_report(file)
        json = json_xcresult_report(file)

        summarized_report = json["targets"].map do |target|
          {
            'target' => target["name"],
            'lineCoverage' => target["lineCoverage"]
          }
        end

        if summarized_report.count > 1
          summarized_report.unshift(
            {
              'target' => 'Total',
              'lineCoverage' => json["lineCoverage"]
            }
          )
        end

        summarized_report
      end
    end
  end
end

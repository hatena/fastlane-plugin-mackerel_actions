require 'fastlane/action'
require_relative '../helper/mackerel_post_xcresult_helper'

module Fastlane
  module Actions
    module SharedValues
    end

    class MackerelPostXcresultAction < Action
      def self.run(params)
        require 'fastlane/plugin/mackerel_api'
        require 'fastlane/plugin/xcresult_actions'
        summarized_report = SummarizeXcresultReportAction.run(
          file: params[:file]
        )
        now = Time.new.to_i
        body = summarized_report.map do |row|
          {
            "name" => "#{params[:metric_name_prefix]}.#{row['target'].gsub('.', '_')}",
            "time" => now,
            "value" => (row['lineCoverage'].to_f * 100).round(1)
          }
        end
        UI.message(body)

        result = MackerelApiAction.run(
          server_url: params[:server_url] || 'https://api.mackerelio.com',
          api_key: params[:api_key],
          http_method: "POST",
          path: "api/v0/services/#{params[:service_name]}/tsdb",
          body: body
        )

        UI.message(result)
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Posting xcresult to Mackerel's Service Metrics"
      end

      def self.details
        [
          "Posting xcresult to Mackerel's Service Metrics.",
          "Documentation: [https://mackerel.io/ja/api-docs/entry/service-metrics#post](https://mackerel.io/ja/api-docs/entry/service-metrics#post)"
        ].join("\n")
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :server_url,
                                       env_name: "FL_MACKEREL_POST_XCRESULT_SERVER_URL",
                                       description: "The server url. e.g. 'https://api.mackerelio.com'",
                                       default_value: "https://api.mackerelio.com",
                                       optional: true,
                                       verify_block: proc do |value|
                                         UI.user_error!("Please include the protocol in the server url, e.g. https://api.mackerelio.com") unless value.include?("//")
                                       end),
          FastlaneCore::ConfigItem.new(key: :api_key,
                                       env_name: "FL_MACKEREL_POST_XCRESULT_API_KEY",
                                       description: "API key for Mackerel - generate one at https://mackerel.io/my?tab=apikeys",
                                       sensitive: true,
                                       code_gen_sensitive: true,
                                       is_string: true,
                                       default_value: ENV["MACKEREL_API_KEY"],
                                       default_value_dynamic: true,
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :service_name,
                                       env_name: "FL_MACKEREL_POST_XCRESULT_SERVICE_NAME",
                                       description: "Service name for Mackerel",
                                       is_string: true,
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :metric_name_prefix,
                                        env_name: "FL_MACKEREL_POST_XCRESULT_METRIC_NAME_PREFIX",
                                        description: "Metric name prefix for Mackerel. Default is `xcresult`",
                                        default_value: "xcresult",
                                        is_string: true,
                                        optional: true),
          FastlaneCore::ConfigItem.new(key: :file,
                                       env_name: "FL_MACKEREL_POST_XCRESULT_FILE",
                                       description: "`.xcresult` file to operate on",
                                       type: String,
                                       optional: false,
                                       verify_block: proc do |value|
                                         UI.user_error!("Please specify an extension of .xcresult") unless File.extname(value) == '.xcresult'
                                       end)
        ]
      end

      def self.output
        []
      end

      def self.return_value
        "none"
      end

      def example_code
        [
          'result = mackerel_post_xcresult(
            api_key: ENV["MACKEREL_API_KEY"],
            service_name: ENV["MACKEREL_SERVICE_NAME"],
            metric_name_prefix: "xcresult",
            file: "build/Logs/Test/Xxxxxx.xcresult"
          )',
          'MackerelPostXcresultAction.run(
            api_key: ENV["MACKEREL_API_KEY"],
            service_name: ENV["MACKEREL_SERVICE_NAME"],
            metric_name_prefix: "xcresult",
            file: "build/Logs/Test/Xxxxxx.xcresult"
          )'
        ]
      end

      def self.authors
        ["yutailang0119"]
      end

      def self.is_supported?(platform)
        [:ios, :mac].include?(platform)
      end
    end
  end
end

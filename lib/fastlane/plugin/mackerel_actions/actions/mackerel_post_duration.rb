require 'fastlane/action'
require_relative '../helper/mackerel_post_duration_helper'

module Fastlane
  module Actions
    module SharedValues
    end

    class MackerelPostDurationAction < Action
      def self.run(params)
        require 'fastlane/plugin/mackerel_api'
        start_time = Helper::MackerelPostDurationHelper.verify_time(params[:start_time])
        now = Time.new.to_i
        duration = (now.to_f - start_time.to_f) / 60
        UI.message("Duration: #{duration}")

        result = MackerelApiAction.run(
          server_url: params[:server_url] || 'https://api.mackerelio.com',
          api_key: params[:api_key],
          http_method: "POST",
          path: "/api/v0/services/#{params[:service_name]}/tsdb",
          body: [
            {
              "name" => params[:metric_name],
              "time" => now,
              "value" => duration
            }
          ],
          error_handlers: {
            403 => proc do |response|
              UI.error("Forbidden")
              UI.user_error!("Mackerel responded with #{response[:status]}\n---\n#{response[:body]}")
            end,
            404 => proc do |response|
              UI.error("Something went wrong - I couldn\'t find it...")
              UI.user_error!("Mackerel responded with #{response[:status]}\n---\n#{response[:body]}")
            end,
            429 => proc do |response|
              UI.error("Too Many Requests")
              UI.user_error!("Mackerel responded with #{response[:status]}\n---\n#{response[:body]}")
            end,
            503 => proc do |response|
              UI.message("Mackerel is under maintenance.")
              UI.message("Mackerel responded with #{response[:status]}\n---\n#{response[:body]}")
            end,
            '*' => proc do |response|
              UI.message("Handle all error codes other")
            end
          }
        )

        UI.message(result)
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Posting duration minutes to Mackerel's Service Metrics"
      end

      def self.details
        [
          "Posting duration minutes to Mackerel's Service Metrics.",
          "Documentation: [https://mackerel.io/ja/api-docs/entry/service-metrics#post](https://mackerel.io/ja/api-docs/entry/service-metrics#post)"
        ].join("\n")
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :server_url,
                                       env_name: "FL_MACKEREL_POST_DURATION_SERVER_URL",
                                       description: "The server url. e.g. 'https://api.mackerelio.com'",
                                       default_value: "https://api.mackerelio.com",
                                       optional: true,
                                       verify_block: proc do |value|
                                         UI.user_error!("Please include the protocol in the server url, e.g. https://api.mackerelio.com") unless value.include?("//")
                                       end),
          FastlaneCore::ConfigItem.new(key: :api_key,
                                       env_name: "FL_MACKEREL_POST_DURATION_API_KEY",
                                       description: "API key for Mackerel - generate one at https://mackerel.io/my?tab=apikeys",
                                       sensitive: true,
                                       code_gen_sensitive: true,
                                       is_string: true,
                                       default_value: ENV["MACKEREL_API_KEY"],
                                       default_value_dynamic: true,
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :service_name,
                                       env_name: "FL_MACKEREL_POST_DURATION_SERVICE_NAME",
                                       description: "Service name for Mackerel",
                                       is_string: true,
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :metric_name,
                                       env_name: "FL_MACKEREL_POST_DURATION_METRIC_NAME",
                                       description: "Metric name for Mackerel",
                                       is_string: true,
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :start_time,
                                       env_name: "FL_MACKEREL_POST_XCRESULT_START_TIME",
                                       description: "Start time of the process to be recorded",
                                       is_string: false,
                                       optional: false)
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
          'result = mackerel_post_duration(
            api_key: ENV["MACKEREL_API_KEY"],
            service_name: ENV["MACKEREL_SERVICE_NAME"],
            metric_name: "duration.#{ENV["FASTLANE_LANE_NAME"]}",
            start_time: Time.now
          )',
          'MackerelPostDurationAction.run(
            api_key: ENV["MACKEREL_API_KEY"],
            service_name: ENV["MACKEREL_SERVICE_NAME"],
            metric_name: "duration.#{ENV["FASTLANE_LANE_NAME"]}",
            start_time: Time.now
          )'
        ]
      end

      def self.authors
        ["yutailang0119"]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end

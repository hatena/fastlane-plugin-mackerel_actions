module Fastlane
  module Helper
    class MackerelPostDurationHelper
      def self.verify_time(value)
        case value
        when Integer
          return value
        when Time
          return value.to_i
        when String
          require 'time'
          timestamp = begin
                        Time.parse(value).to_i
                      rescue
                        nil
                      end
          UI.user_error!("Invalid option: #{value.inspect}") if timestamp.nil?
          return timestamp
        else
          UI.user_error!("Invalid option: #{value.inspect}")
        end
      end
    end
  end
end

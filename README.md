# mackerel_actions plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-mackerel_actions)
[![Test](https://github.com/yutailang0119/fastlane-plugin-mackerel_actions/workflows/Test/badge.svg)](https://github.com/yutailang0119/fastlane-plugin-mackerel_actions/actions?query=branch%3Amaster+workflow%3ATest)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-mackerel_actions`, add it to your project to Pluginfile:

```bash
gem "add_plugin mackerel_actions", git: "https://github.com/yutailang0119/fastlane-plugin-mackerel_actions"
```

## About mackerel_actions

fastlane actions for Mackerel.

This actions use [yutailang0119/fastlane-plugin-mackerel_api](https://github.com/yutailang0119/fastlane-plugin-mackerel_api) to call [Mackerel API](https://mackerel.io/api-docs/).

- mackerel_post_duration
    - Posting duration minutes to Mackerel's Service Metrics.
- mackerel_post_xcresult
    - Posting xcresult summary to Mackerel's Service Metrics

## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins` and:

- `bundle exec fastlane post_duration`
- `bundle exec fastlane post_xcresult`

## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).

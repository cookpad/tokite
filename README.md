# Tokite [![CircleCI](https://circleci.com/gh/hogelog/tokite.svg?style=svg)](https://circleci.com/gh/hogelog/tokite) [![Gem Version](https://badge.fury.io/rb/tokite.svg)](https://badge.fury.io/rb/tokite)

Tokite send GitHub event (pull-request, issue and comment) to Slack.
 
Notification setting are personalized and customizable by query.

## Installation
Tokite works as rails mountable engine.

Add this line to your rails application's Gemfile:
```ruby
gem "tokite"
```

And mount engine.

```ruby
Rails.application.routes.draw do
  mount Tokite::Engine => "/"
end
```

### Setup database
```console
$ ./bin/rails db:create
$ ./bin/rails tokite:ridgepole:install
$ ./bin/rails tokite:ridgepole:apply
```

### Setup yarn pkg
```console
$ ./bin/rails tokite:yarn:install
```

## Configuration
<table>
<tr><th>GITHUB_CLIENT_ID</th><td>Google+ OAuth2 client ID</td></tr>
<tr><th>GITHUB_CLIENT_SECRET</th><td>Google+ OAuth2 client secret</td></tr>
<tr><th>GITHUB_HOST (optional)</th><td>GitHub Enterprise host</td></tr>
<tr><th>SECRET_KEY_BASE</th><td><code>rails secret</code> key</td></tr>
<tr><th>SLACK_WEBHOOK_URL</th><td>Slack incoming webhook url</td></tr>
<tr><th>SLACK_NAME (optional)</th><td>Slack notification user name</td></tr>
<tr><th>SLACK_ICON_EMOJI (optional)</th><td>Slack notification icon</td></tr>
<tr><th>APP_HOST (optional)</th><td>Application host url</td></tr>
</table>

## Usage
### Supported Event

Tokite support only below events now.

- pull_request
- issues
- issue_comment

### Supported query type

<table>
<tr><th>Name</th><th>Example</th></tr>
<tr><td>Plain word</td><td>hoge fuga moge</td></tr>
<tr><td>Quoted word</td><td>"hoge fuga moge"</td></tr>
<tr><td>Regular expression word</td><td>/hoge|fuga|moge/</td></tr>
<tr><td>Exclude word</td><td> -/(hoge|fuga|moge)/ -user:hogelog</td></tr>
</table>

### Supported query field

<table>
<tr><th>Name</th><th>Description</th><th>Example</th></tr>
<tr><td>repo:</td><td>Match repository name.</td><td>repo:hogelog/tokite</td></tr>
<tr><td>title:</td><td>Match pull_request or issues title.</td><td>title:Bug</td></tr>
<tr><td>event:</td><td>Match event type pull_request, issues, issue_comment, pull_request_review, pull_request_review_comment.</td><td>event:/pull_request|issues|pull_request_review|pull_request_review_comment/</td></tr>
<tr><td>body:</td><td>Match body text.</td><td>body:"review please"</td></tr>
<tr><td>user:</td><td>Match user name.</td><td>user:hogelog</td></tr>
<tr><td>review_state:</td><td>Match pull_request_review state.</td><td>review_state:/commented|approved|requested_changes/</td></tr>
<tr><td>unspecified</td><td>Match title or body field.</td><td>review please</td></tr>
</table>

# Tokite

Tokite send GitHub event (pull-request, issue and comment) to Slack.
 
Notification setting are personalized and customizable by query.

## Development
```console
$ ./bin/setup
$ vim .env
...
$ ./bin/rails s
```

### Configuration
<table>
<tr><th>GOOGLE_CLIENT_ID</th><td>Google+ OAuth2 client ID</td></tr>
<tr><th>GOOGLE_CLIENT_SECRET</th><td>Google+ OAuth2 client secret</td></tr>
<tr><th>GOOGLE_HOSTED_DOMAIN (optional)</th><td>Limited by G Suite domain</td></tr>
<tr><th>SECRET_KEY_BASE</th><td><code>rails secret</code> key</td></tr>
<tr><th>SLACK_WEBHOOK_URL</th><td>Slack incoming webhook url</td></tr>
<tr><th>SLACK_NAME (optional)</th><td>Slack notification user name</td></tr>
<tr><th>SLACK_ICON_EMOJI (optional)</th><td>Slack notification icon</td></tr>
</table>

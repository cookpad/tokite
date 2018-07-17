require "omniauth-github"

Tokite::Engine.config.middleware.use OmniAuth::Builder do
  options = { scope: "repo,write:repo_hook,read:orgs,admin:org_hook" }
  host = ENV["GITHUB_HOST"]
  if host.present?
    options.merge!(
      client_options: {
        site: "#{host}/api/v3",
        authorize_url: "#{host}/login/oauth/authorize",
        token_url: "#{host}/login/oauth/access_token",
      }
    )
  end
  provider :github, ENV["GITHUB_CLIENT_ID"], ENV["GITHUB_CLIENT_SECRET"], options
end

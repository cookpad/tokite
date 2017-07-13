require "octokit"

if ENV["GITHUB_HOST"].present?
  Octokit.configure do |c|
    c.api_endpoint = URI.join(ENV["GITHUB_HOST"], "/api/v3/").to_s
  end
end

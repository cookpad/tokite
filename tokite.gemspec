$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "tokite/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "tokite"
  s.version     = Tokite::VERSION
  s.authors     = ["hogelog"]
  s.email       = ["konbu.komuro@gmail.com"]
  s.homepage    = "https://github.com/cookpad/tokite/"
  s.summary     = "Customizable Slack notification from GitHub"
  s.description = "Customizable Slack notification from GitHub"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib,schema,vendor}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 8.1.0"
  s.add_dependency "pg"

  s.add_dependency "dartsass-rails"
  s.add_dependency "haml-rails"
  s.add_dependency "haml"
  s.add_dependency "octokit"
  s.add_dependency "omniauth-github", ">= 2.0.0"
  s.add_dependency "omniauth-rails_csrf_protection"
  s.add_dependency "parslet"
  s.add_dependency "propshaft"
  s.add_dependency "ridgepole"
  s.add_dependency "slack-notifier"
end

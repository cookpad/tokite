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

  s.files = Dir["{app,config,db,lib,schema}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 7.0.0"
  s.add_dependency "pg"

  s.add_dependency "haml-rails"
  s.add_dependency "haml"
  s.add_dependency "octokit"
  s.add_dependency "omniauth-github", ">= 2.0.0"
  s.add_dependency "omniauth-rails_csrf_protection"
  s.add_dependency "parslet"
  s.add_dependency "ridgepole"
  s.add_dependency "sass-rails", "~> 6.0"
  s.add_dependency "sprockets-rails"
  s.add_dependency "slack-notifier"

  # Workaround before Rails 7.1
  # https://github.com/rails/rails/issues/54260
  # https://github.com/ruby-concurrency/concurrent-ruby/commit/d7ce956dacd0b772273d39b8ed31a30cff7ecf38
  s.add_dependency "concurrent-ruby", "<= 1.3.4"
end

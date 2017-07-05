$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "tokite/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "tokite"
  s.version     = Tokite::VERSION
  s.authors     = ["hogelog"]
  s.email       = ["konbu.komuro@gmail.com"]
  s.homepage    = "https://github.com/hogelog/tokite/"
  s.summary     = "Customizable Slack notification from GitHub"
  s.description = "Customizable Slack notification from GitHub"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.1"
  s.add_dependency "pg", "~> 0.18"
  s.add_dependency 'sass-rails', '~> 5.0'
  s.add_dependency "haml"
  s.add_dependency "haml-rails"
  s.add_dependency "omniauth-github"
  s.add_dependency "slack-notifier"
  s.add_dependency "ridgepole"
  s.add_dependency "parslet"

  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_girl_rails"
end

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.0.0] - 2026-01-28

### Changed

- **BREAKING**: Upgrade Rails to 7.1

### Removed

- Remove Tokite::ApplicationMailer and layouts

## [1.0.0] - 2026-01-28

This is the first major release version. There are no breaking changes between v0.9.0 and v1.0.0.

### Added

- Add GitHub Actions workflow to release gem
- docs: Add instructions to release gem

### Changed

- Organize changelogs

## [0.9.0] - 2026-01-27

### Changed

- **BREAKING**: Change Rails asset pipeline from Sprockets to Propshaft + dartsass-rails. Please follow the official migration guide from Propshaft. You may need to run `bin/rails dartsass:install`. Tokite's assets should be built when running `bin/rails assets:precompile` on your application.

## [0.8.1] - 2026-01-27

### Fixed

- fix: Use button_to for DELETE requests

## [0.8.0] - 2026-01-24

### Changed

- **BREAKING**: Upgrade Rails to 7.0
- Upgrade GitHub Actions workflow version for CI
- Unify development dependencies in gemspec and Gemfile

### Fixed

- fix: Limit version of concurrent-ruby

### Removed

- Remove pry, byebug, and rspec_junit_formatter from development dependencies

## [0.7.1] - 2023-06-15

### Changed

- Upgrade omniauth-github to v2 (https://github.com/cookpad/tokite/pull/66).
    - Please add omniauth-rails_csrf_protection gem to your Gemfile.
- Use Ruby 3.1 for testing (https://github.com/cookpad/tokite/pull/67).

## [0.7.0] - 2023-06-14

### Changed

- **BREAKING**: Upgrade to Rails 6.1 (https://github.com/cookpad/tokite/pull/64).

## [0.6.0] - 2023-06-14

### Changed

- **BREAKING**: Upgrade to Rails 6.0 (https://github.com/cookpad/tokite/pull/61).

## [0.5.1] - 2023-06-14

### Changed

- Upgrade bulma to 0.9.4 (https://github.com/cookpad/tokite/pull/59).

## [0.5.0] - 2023-06-14

We have not released a new version of tokite gem for a long time. Be careful when upgrading to this version from previous versions.

### Added

- **BREAKING**: Add requested_reviewer and requested_team to query field names (https://github.com/cookpad/tokite/pull/53).
    - If you feel these notification are too noisy, please report an issue.
- Add badges for private repositories (https://github.com/cookpad/tokite/pull/41).
- Add input form for editting display name in Slack channel (https://github.com/cookpad/tokite/pull/40).
- Support label query (https://github.com/cookpad/tokite/pull/51).
- Use issue labels info also for issue_comment event (https://github.com/cookpad/tokite/pull/56).

### Changed

- **BREAKING**: Upgrade to Rails 5.2 (https://github.com/cookpad/tokite/pull/57).
- Loose length limit of icon_emoji (https://github.com/cookpad/tokite/pull/46).
- Upgrade rspec version for development (https://github.com/cookpad/tokite/pull/47).
- Use Ruby 2.7 (https://github.com/cookpad/tokite/pull/52).
- Use GitHub Actions for CI (https://github.com/cookpad/tokite/pull/54).

### Fixed

- Fix to treat nil text body in pull_request_review hook (https://github.com/cookpad/tokite/pull/38).
- Fix to check if a repository is archived or not (https://github.com/cookpad/tokite/pull/39).
- Fix to show error message when no repository is selected in `/repositories/new` page (https://github.com/cookpad/tokite/pull/42).
- Fix an error occurred when a query contains wrong regular expressions (https://github.com/cookpad/tokite/pull/43).


[Unreleased]: https://github.com/cookpad/tokite/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/cookpad/tokite/compare/v0.9.0...v1.0.0
[0.9.0]: https://github.com/cookpad/tokite/compare/v0.8.1...v0.9.0
[0.8.1]: https://github.com/cookpad/tokite/compare/v0.8.0...v0.8.1
[0.8.0]: https://github.com/cookpad/tokite/compare/v0.7.1...v0.8.0
[0.7.1]: https://github.com/cookpad/tokite/compare/v0.7.0...v0.7.1
[0.7.0]: https://github.com/cookpad/tokite/compare/v0.6.0...v0.7.0
[0.6.0]: https://github.com/cookpad/tokite/compare/v0.5.1...v0.6.0
[0.5.1]: https://github.com/cookpad/tokite/compare/v0.5.0...v0.5.1
[0.5.0]: https://github.com/cookpad/tokite/compare/v0.4.1...v0.5.0

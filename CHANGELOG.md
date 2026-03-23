# Changelog

All notable changes to this gem will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this gem adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
n## [0.1.4] - 2026-03-22

### Changed
- Fix README badges to match template (Tests, Gem Version, License)
n## [0.1.3] - 2026-03-22

### Changed
- Add License badge to README

## [0.1.2] - 2026-03-22

### Fixed

- Fix CHANGELOG header wording
- Add bug_tracker_uri to gemspec

## [0.1.1] - 2026-03-22

### Changed
- Improve source code, tests, and rubocop compliance

## [0.1.0] - 2026-03-22

### Added

- Initial release
- Configurable password policy validation (length, complexity, common passwords)
- Entropy-based strength scoring (0-4 scale: terrible/weak/fair/strong/excellent)
- Secure random password generation with character class guarantees
- Passphrase generation from built-in word list
- PIN generation (digits only)
- Built-in list of ~100 common passwords for rejection

[Unreleased]: https://github.com/philiprehberger/rb-password/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/philiprehberger/rb-password/releases/tag/v0.1.0

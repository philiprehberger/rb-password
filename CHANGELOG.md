# Changelog

All notable changes to this gem will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this gem adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.3.0] - 2026-04-05

### Added
- `Password.common?(password)` method for standalone common password checking
- `custom_passwords:` option on `Policy.new` for supplying additional banned passwords

### Fixed
- Gemspec author, email, Ruby version format, and files glob to match template guide

## [0.2.2] - 2026-03-31

### Added
- Add GitHub issue templates, dependabot config, and PR template

## [0.2.1] - 2026-03-31

### Changed
- Standardize README badges, support section, and license format

## [0.2.0] - 2026-03-28

### Added
- Common password dictionary with 10,000+ entries stored as a frozen Set for O(1) lookup
- Keyboard pattern detection: `Password.keyboard_patterns(pwd)` detects QWERTY rows, alphabetic/numeric sequences, and repeated characters
- Context-aware policy validation: `policy.validate(pwd, context: { username:, email:, app_name: })` rejects passwords containing personal information
- Password hashing integration via bcrypt wrapper: `Password.hash(pwd, cost: 12)` and `Password.verify(pwd, hash)` with lazy loading and helpful error if bcrypt is not installed
- Expanded passphrase word list from 41 to 200+ words sourced from BIP39/EFF lists
- zxcvbn-style strength estimation: `Password.zxcvbn(pwd)` returns pattern-based scoring with dictionary word detection, l33t substitution detection, spatial keyboard patterns, and date patterns

### Changed
- Policy now uses expanded CommonPasswords dictionary instead of inline ~100 password list
- Generator WORD_LIST expanded to 200+ unique lowercase words for better passphrase entropy

## [0.1.9] - 2026-03-26

### Fixed
- Add Sponsor badge to README
- Fix license section link format

## [0.1.8] - 2026-03-24

### Fixed
- Fix stray character in CHANGELOG formatting

## [0.1.7] - 2026-03-24

### Fixed
- Standardize README code examples to use double-quote require statements

## [0.1.6] - 2026-03-24

### Fixed
- Fix Installation section quote style to double quotes

## [0.1.5] - 2026-03-23

### Fixed
- Standardize README to match template guide

## [0.1.4] - 2026-03-22

### Changed
- Fix README badges to match template (Tests, Gem Version, License)

## [0.1.3] - 2026-03-22

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

[Unreleased]: https://github.com/philiprehberger/rb-password/compare/v0.3.0...HEAD
[0.3.0]: https://github.com/philiprehberger/rb-password/compare/v0.2.2...v0.3.0
[0.2.0]: https://github.com/philiprehberger/rb-password/compare/v0.1.9...v0.2.0
[0.1.0]: https://github.com/philiprehberger/rb-password/releases/tag/v0.1.0

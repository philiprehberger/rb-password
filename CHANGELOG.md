# Changelog

All notable changes to this gem will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this gem adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.9.0] - 2026-07-15

### Added
- `Password.secure_compare(a, b)` — timing-safe secret comparison backed by stdlib `OpenSSL.fixed_length_secure_compare`, with a length-masked constant-time fallback for differing lengths (no new dependencies).
- Generator charset controls: `exclude_ambiguous: true` drops visually ambiguous characters (`0 O o l I 1`), and `symbols:` (array) / `symbol_set:` (string) supply a custom symbol pool.
- Generator `style: :pronounceable` — easy-to-say passwords built from alternating consonant/vowel positions with optional digit/symbol injection.

### Fixed
- `Password.strength` now returns the documented `:feedback` array of actionable suggestions (length, character-class, sequence, and common-password guidance); the key was promised in the docstring but never populated. Feedback is empty for strong passwords.

## [0.8.1] - 2026-06-14

### Changed
- Added package card image to README
- Added YARD doc comments to public API methods

## [0.8.0] - 2026-05-13

### Added
- `Password.strong?(password, threshold: 3)` — predicate returning `true` when `score >= threshold`. Default threshold corresponds to the "strong" tier on the 0-4 scale.

## [0.7.0] - 2026-04-27

### Added
- `Password.batch_strength(passwords)` — grade an enumerable of passwords in one call; returns an array of strength hashes in input order. Non-string elements are coerced via `to_s`. Raises `ArgumentError` for non-enumerable input.

## [0.6.0] - 2026-04-23

### Added
- `Password.score(password)` — convenience accessor returning the 0-4 integer score without the full `strength` hash

## [0.5.0] - 2026-04-20

### Added
- `Password.mask(password, visible: 0, mask: '*')` — redact a password for logs or UI while preserving the original length. Reveals the trailing `visible` characters (defaults to none) and supports a custom single-character `mask`.

## [0.4.0] - 2026-04-15

### Added
- `Password.entropy(password)` — top-level accessor for the entropy-bits estimate already exposed by `Strength`

## [0.3.3] - 2026-04-09

### Fixed
- Replace hardcoded version assertion in spec with `not_to be_nil`.

## [0.3.2] - 2026-04-08

### Changed
- Align gemspec summary with README description.

## [0.3.1] - 2026-04-07

### Changed
- `Hashing.hash` validates input: raises `ArgumentError` on non-String, empty password, or out-of-range cost (4-31)
- `Hashing.verify` returns `false` for nil/empty/non-String inputs and malformed bcrypt hashes instead of raising

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

[Unreleased]: https://github.com/philiprehberger/rb-password/compare/v0.9.0...HEAD
[0.9.0]: https://github.com/philiprehberger/rb-password/compare/v0.8.1...v0.9.0
[0.8.1]: https://github.com/philiprehberger/rb-password/compare/v0.8.0...v0.8.1
[0.8.0]: https://github.com/philiprehberger/rb-password/compare/v0.7.0...v0.8.0
[0.7.0]: https://github.com/philiprehberger/rb-password/compare/v0.6.0...v0.7.0
[0.6.0]: https://github.com/philiprehberger/rb-password/compare/v0.5.0...v0.6.0
[0.5.0]: https://github.com/philiprehberger/rb-password/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/philiprehberger/rb-password/compare/v0.3.3...v0.4.0
[0.3.3]: https://github.com/philiprehberger/rb-password/compare/v0.3.2...v0.3.3
[0.3.2]: https://github.com/philiprehberger/rb-password/compare/v0.3.1...v0.3.2
[0.3.1]: https://github.com/philiprehberger/rb-password/compare/v0.3.0...v0.3.1
[0.3.0]: https://github.com/philiprehberger/rb-password/compare/v0.2.2...v0.3.0
[0.2.2]: https://github.com/philiprehberger/rb-password/compare/v0.2.1...v0.2.2
[0.2.1]: https://github.com/philiprehberger/rb-password/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/philiprehberger/rb-password/compare/v0.1.9...v0.2.0
[0.1.9]: https://github.com/philiprehberger/rb-password/compare/v0.1.8...v0.1.9
[0.1.8]: https://github.com/philiprehberger/rb-password/compare/v0.1.7...v0.1.8
[0.1.7]: https://github.com/philiprehberger/rb-password/compare/v0.1.6...v0.1.7
[0.1.6]: https://github.com/philiprehberger/rb-password/compare/v0.1.5...v0.1.6
[0.1.5]: https://github.com/philiprehberger/rb-password/compare/v0.1.4...v0.1.5
[0.1.4]: https://github.com/philiprehberger/rb-password/compare/v0.1.3...v0.1.4
[0.1.3]: https://github.com/philiprehberger/rb-password/compare/v0.1.2...v0.1.3
[0.1.2]: https://github.com/philiprehberger/rb-password/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/philiprehberger/rb-password/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/philiprehberger/rb-password/releases/tag/v0.1.0

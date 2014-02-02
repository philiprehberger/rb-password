# Changelog

All notable changes to this gem will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2026-03-21

### Added
- Initial release
- Password strength scoring (0-4) with entropy-based analysis
- Configurable policy validation (length, complexity, common passwords)
- Common password dictionary with ~100 entries for breach checking
- Secure password generation with character class guarantees
- Passphrase generation from bundled word list
- Entropy calculation based on character pool size

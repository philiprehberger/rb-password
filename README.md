# philiprehberger-password

[![Tests](https://github.com/philiprehberger/rb-password/actions/workflows/ci.yml/badge.svg)](https://github.com/philiprehberger/rb-password/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/philiprehberger-password.svg)](https://rubygems.org/gems/philiprehberger-password)
[![License](https://img.shields.io/github/license/philiprehberger/rb-password)](LICENSE)

Password strength checking, policy validation, and secure generation

## Requirements

- Ruby >= 3.1

## Installation

Add to your Gemfile:

```ruby
gem 'philiprehberger-password'
```

Or install directly:

```bash
gem install philiprehberger-password
```

## Usage

```ruby
require 'philiprehberger/password'

# Strength scoring
result = Philiprehberger::Password.strength('MyP@ssw0rd!')
result[:score]    # => 3
result[:label]    # => :strong
result[:entropy]  # => 72.08
```

### Policy Validation

```ruby
result = Philiprehberger::Password.validate('short',
  min_length: 12,
  require_uppercase: true,
  require_digit: true
)
result.valid?   # => false
result.errors   # => ["Must be at least 12 characters", ...]
```

### Password Generation

```ruby
Philiprehberger::Password.generate(length: 20)
# => "kX9#mZ2!pQ7@wR4bN5&j"

Philiprehberger::Password.passphrase(words: 4)
# => "correct-horse-battery-stable"
```

### Breach Checking

```ruby
Philiprehberger::Password.breached?('password')  # => true
Philiprehberger::Password.breached?('xK9#mZ2!')  # => false
```

### Entropy

```ruby
Philiprehberger::Password.entropy('abc')       # => 14.1
Philiprehberger::Password.entropy('aBc123!@')  # => 52.56
```

## API

### `Philiprehberger::Password`

| Method | Description |
|--------|-------------|
| `.strength(password)` | Score 0-4 with label and entropy |
| `.validate(password, **policy)` | Validate against policy rules |
| `.entropy(password)` | Calculate entropy in bits |
| `.generate(length:, charset:)` | Generate secure random password |
| `.passphrase(words:, separator:)` | Generate word-based passphrase |
| `.breached?(password)` | Check against common password list |

### `Philiprehberger::Password::Policy`

| Method | Description |
|--------|-------------|
| `.new(**options)` | Create policy with min_length, require_uppercase, etc. |
| `#validate(password)` | Returns result with `valid?` and `errors` |

## Development

```bash
bundle install
bundle exec rspec      # Run tests
bundle exec rubocop    # Check code style
```

## License

MIT

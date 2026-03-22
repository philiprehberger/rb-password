# philiprehberger-password

[![Gem Version](https://badge.fury.io/rb/philiprehberger-password.svg)](https://badge.fury.io/rb/philiprehberger-password)
$badge_line
[![CI](https://github.com/philiprehberger/rb-password/actions/workflows/ci.yml/badge.svg)](https://github.com/philiprehberger/rb-password/actions/workflows/ci.yml)

Password strength checking, policy validation, and secure generation.

## Requirements

- Ruby >= 3.1

## Installation

Add to your Gemfile:

```ruby
gem 'philiprehberger-password'
```

Or install directly:

```sh
gem install philiprehberger-password
```

## Usage

### Strength Scoring

```ruby
require 'philiprehberger/password'

result = Philiprehberger::Password.strength('MyP@ssw0rd!')
result[:score]    # => 3
result[:label]    # => :strong
result[:entropy]  # => 72.08
```

### Policy Validation

```ruby
policy = Philiprehberger::Password::Policy.new(
  min_length: 12,
  require_uppercase: true,
  require_digit: true,
  require_symbol: true,
  reject_common: true
)

result = policy.validate('short')
result.valid?  # => false
result.errors  # => ["must be at least 12 characters", ...]
result.score   # => 0
```

### Password Generation

```ruby
# Random password
Philiprehberger::Password.generate(length: 20)
# => "kX9#mZ2!pQ7@wR4bN5&j"

# Passphrase
Philiprehberger::Password.generate(style: :passphrase, words: 4, separator: '-')
# => "correct-horse-battery-staple"

# PIN
Philiprehberger::Password.generate(style: :pin, length: 6)
# => "482917"
```

## API

### `Philiprehberger::Password`

| Method | Description |
|--------|-------------|
| `.strength(password)` | Returns hash with `:score` (0-4), `:label`, `:entropy` |
| `.generate(**options)` | Generate a password (see options below) |

### Generate Options

| Option | Default | Description |
|--------|---------|-------------|
| `length` | 16 | Password length |
| `uppercase` | true | Include uppercase letters |
| `lowercase` | true | Include lowercase letters |
| `digits` | true | Include digits |
| `symbols` | true | Include symbols |
| `style` | nil | `:passphrase` or `:pin` for alternative styles |
| `words` | 4 | Word count for passphrase style |
| `separator` | "-" | Separator for passphrase style |

### `Philiprehberger::Password::Policy`

| Method | Description |
|--------|-------------|
| `.new(**options)` | Create policy (min_length, max_length, require_uppercase, require_lowercase, require_digit, require_symbol, reject_common) |
| `#validate(password)` | Returns Result with `.valid?`, `.errors`, `.score` |

### Strength Labels

| Score | Label | Entropy |
|-------|-------|---------|
| 0 | `:terrible` | < 28 bits |
| 1 | `:weak` | < 36 bits |
| 2 | `:fair` | < 60 bits |
| 3 | `:strong` | < 80 bits |
| 4 | `:excellent` | >= 80 bits |

## Development

```sh
bundle install
bundle exec rspec
bundle exec rubocop
```

## License

MIT License. See [LICENSE](LICENSE) for details.

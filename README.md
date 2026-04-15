# philiprehberger-password

[![Tests](https://github.com/philiprehberger/rb-password/actions/workflows/ci.yml/badge.svg)](https://github.com/philiprehberger/rb-password/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/philiprehberger-password.svg)](https://rubygems.org/gems/philiprehberger-password)
[![Last updated](https://img.shields.io/github/last-commit/philiprehberger/rb-password)](https://github.com/philiprehberger/rb-password/commits/main)

Password strength checking, policy validation, pattern detection, hashing, and secure generation

## Requirements

- Ruby >= 3.1
- bcrypt gem (optional, for password hashing only)

## Installation

Add to your Gemfile:

```ruby
gem "philiprehberger-password"
```

Or install directly:

```bash
gem install philiprehberger-password
```

## Usage

### Strength Scoring

```ruby
require "philiprehberger/password"

result = Philiprehberger::Password.strength("MyP@ssw0rd!")
result[:score]    # => 3
result[:label]    # => :strong
result[:entropy]  # => 72.08
```

### Entropy Estimate

Estimated password entropy in bits — `length * log2(pool_size)` where the pool is inferred from the character classes present:

```ruby
Philiprehberger::Password.entropy("aaaaaa")       # => 28.20
Philiprehberger::Password.entropy("MyP@ssw0rd!")  # => 72.08
Philiprehberger::Password.entropy("")             # => 0.0
```

### Common Password Check

```ruby
Philiprehberger::Password.common?("password")   # => true
Philiprehberger::Password.common?("xK9#mZ2!pQ") # => false
```

### Policy Validation

```ruby
policy = Philiprehberger::Password::Policy.new(
  min_length: 12,
  require_uppercase: true,
  require_digit: true,
  require_symbol: true,
  reject_common: true,
  custom_passwords: ["companyname", "internalpass"]
)

result = policy.validate("short")
result.valid?  # => false
result.errors  # => ["must be at least 12 characters", ...]
result.score   # => 0
```

### Context-Aware Validation

```ruby
policy = Philiprehberger::Password::Policy.new

result = policy.validate("johndoe2024!", context: {
  username: "johndoe",
  email: "johndoe@example.com",
  app_name: "myapp"
})
result.valid?  # => false
result.errors  # => ["must not contain your username", "must not contain your email username"]
```

### Keyboard Pattern Detection

```ruby
patterns = Philiprehberger::Password.keyboard_patterns("qwertyaaa123456")
# => [
#   { type: :keyboard_row, token: "qwerty", start: 0, length: 6, direction: :forward },
#   { type: :repeated, token: "aaa", start: 6, length: 3, repeated_char: "a" },
#   { type: :sequence, token: "123456", start: 9, length: 6, sequence_type: :numeric, direction: :ascending }
# ]
```

### Password Hashing

```ruby
# Requires bcrypt gem: gem install bcrypt
hash = Philiprehberger::Password.hash("my-secret-password", cost: 12)
# => "$2a$12$..."

Philiprehberger::Password.verify("my-secret-password", hash)
# => true

Philiprehberger::Password.verify("wrong-password", hash)
# => false
```

### Password Generation

```ruby
# Random password
Philiprehberger::Password.generate(length: 20)
# => "kX9#mZ2!pQ7@wR4bN5&j"

# Passphrase (200+ word list)
Philiprehberger::Password.generate(style: :passphrase, words: 4, separator: "-")
# => "correct-horse-battery-staple"

# PIN
Philiprehberger::Password.generate(style: :pin, length: 6)
# => "482917"
```

### zxcvbn-Style Strength Estimation

```ruby
result = Philiprehberger::Password.zxcvbn("p@ssw0rd123")
result[:score]              # => 1
result[:crack_time_display] # => "minutes"
result[:patterns]           # => [{ type: :leet, token: "p@ssw0rd", ... }, ...]
```

## API

### `Philiprehberger::Password`

| Method | Description |
|--------|-------------|
| `.common?(password)` | Returns `true` if password is in the common password dictionary |
| `.strength(password)` | Returns hash with `:score` (0-4), `:label`, `:entropy` |
| `.entropy(password)` | Estimated entropy in bits (Float) |
| `.generate(**options)` | Generate a password (see options below) |
| `.keyboard_patterns(password)` | Returns array of detected keyboard/sequence/repeat patterns |
| `.hash(password, cost: 12)` | Hash password with bcrypt (requires bcrypt gem) |
| `.verify(password, hash)` | Verify password against bcrypt hash (requires bcrypt gem) |
| `.zxcvbn(password)` | Returns hash with `:score` (0-4), `:patterns`, `:crack_time_display` |

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
| `.new(**options)` | Create policy (min_length, max_length, require_uppercase, require_lowercase, require_digit, require_symbol, reject_common, custom_passwords) |
| `#validate(password, context: {})` | Returns Result with `.valid?`, `.errors`, `.score`. Context accepts `:username`, `:email`, `:app_name` |

### Strength Labels

| Score | Label | Entropy |
|-------|-------|---------|
| 0 | `:terrible` | < 28 bits |
| 1 | `:weak` | < 36 bits |
| 2 | `:fair` | < 60 bits |
| 3 | `:strong` | < 80 bits |
| 4 | `:excellent` | >= 80 bits |

### zxcvbn Pattern Types

| Type | Description |
|------|-------------|
| `:dictionary` | Common password or known word detected |
| `:leet` | L33t-speak substitution of a known word |
| `:spatial` | QWERTY keyboard adjacency pattern |
| `:date` | Date pattern (yyyy, mm/dd/yyyy, etc.) |
| `:sequence` | Alphabetic or numeric sequence |
| `:repeated` | Repeated characters |

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## Support

If you find this project useful:

⭐ [Star the repo](https://github.com/philiprehberger/rb-password)

🐛 [Report issues](https://github.com/philiprehberger/rb-password/issues?q=is%3Aissue+is%3Aopen+label%3Abug)

💡 [Suggest features](https://github.com/philiprehberger/rb-password/issues?q=is%3Aissue+is%3Aopen+label%3Aenhancement)

❤️ [Sponsor development](https://github.com/sponsors/philiprehberger)

🌐 [All Open Source Projects](https://philiprehberger.com/open-source-packages)

💻 [GitHub Profile](https://github.com/philiprehberger)

🔗 [LinkedIn Profile](https://www.linkedin.com/in/philiprehberger)

## License

[MIT](LICENSE)

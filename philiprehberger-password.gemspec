# frozen_string_literal: true

require_relative 'lib/philiprehberger/password/version'

Gem::Specification.new do |spec|
  spec.name = 'philiprehberger-password'
  spec.version = Philiprehberger::Password::VERSION
  spec.authors = ['Philip Rehberger']
  spec.email = ['me@philiprehberger.com']

  spec.summary = 'Password strength checking, policy validation, and secure generation'
  spec.description = 'Validate passwords against configurable policies (length, complexity, ' \
                     'common password dictionary, context-aware checks), score strength with ' \
                     'entropy-based and zxcvbn-style analysis, detect keyboard patterns and ' \
                     'sequences, hash with bcrypt, and generate secure random passwords, ' \
                     'passphrases, and PINs.'
  spec.homepage = 'https://philiprehberger.com/open-source-packages/ruby/philiprehberger-password'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.1.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/philiprehberger/rb-password'
  spec.metadata['changelog_uri'] = 'https://github.com/philiprehberger/rb-password/blob/main/CHANGELOG.md'
  spec.metadata['bug_tracker_uri'] = 'https://github.com/philiprehberger/rb-password/issues'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir['lib/**/*.rb', 'LICENSE', 'README.md', 'CHANGELOG.md']
  spec.require_paths = ['lib']
end

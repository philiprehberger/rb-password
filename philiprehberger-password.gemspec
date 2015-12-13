# frozen_string_literal: true

require_relative 'lib/philiprehberger/password/version'

Gem::Specification.new do |spec|
  spec.name = 'philiprehberger-password'
  spec.version = Philiprehberger::Password::VERSION
  spec.authors = ['philiprehberger']
  spec.email = ['philiprehberger@users.noreply.github.com']

  spec.summary = 'Password strength checking, policy validation, and secure generation'
  spec.description = 'Validate passwords against configurable policies (length, complexity, ' \
                     'common password dictionary), score strength with entropy-based analysis, ' \
                     'and generate secure random passwords, passphrases, and PINs.'
  spec.homepage = 'https://github.com/philiprehberger/rb-password'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.1'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir['lib/**/*', 'LICENSE', 'README.md', 'CHANGELOG.md']
  spec.require_paths = ['lib']
end

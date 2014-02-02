# frozen_string_literal: true

require_relative 'password/version'
require_relative 'password/common_passwords'
require_relative 'password/strength'
require_relative 'password/policy'
require_relative 'password/generator'

module Philiprehberger
  module Password
    def self.strength(password)
      Strength.score(password)
    end

    def self.entropy(password)
      Strength.entropy(password)
    end

    def self.validate(password, **policy_options)
      policy = Policy.new(**policy_options)
      policy.validate(password)
    end

    def self.generate(length: 16, charset: :all)
      Generator.generate(length: length, charset: charset)
    end

    def self.passphrase(words: 4, separator: '-')
      Generator.passphrase(words: words, separator: separator)
    end

    def self.breached?(password)
      return false if password.nil? || password.empty?

      COMMON_PASSWORDS.include?(password.downcase)
    end
  end
end

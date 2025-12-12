# frozen_string_literal: true

require 'set'

require_relative 'password/version'
require_relative 'password/common_passwords'
require_relative 'password/strength'
require_relative 'password/patterns'
require_relative 'password/policy'
require_relative 'password/generator'
require_relative 'password/hashing'
require_relative 'password/zxcvbn'

module Philiprehberger
  module Password
    # Check if a password appears in the common password dictionary.
    #
    # @param password [String] the password to check
    # @return [Boolean] true if the password is common
    def self.common?(password)
      CommonPasswords.include?(password.to_s.downcase)
    end

    def self.strength(password)
      Strength.compute(password)
    end

    # Estimated entropy of the password in bits (log2(pool_size ^ length)).
    # Pool size is inferred from the character classes present.
    #
    # @param password [String] the password to evaluate
    # @return [Float] estimated entropy in bits (0.0 for empty passwords)
    def self.entropy(password)
      Strength.entropy(password)
    end

    def self.generate(**options)
      Generator.generate(**options)
    end

    # Detect keyboard patterns, sequences, and repeated characters.
    # Returns an array of pattern hashes.
    def self.keyboard_patterns(password)
      Patterns.detect(password)
    end

    # Hash a password using bcrypt.
    # Requires the bcrypt gem to be installed.
    def self.hash(password, cost: 12)
      Hashing.hash(password, cost: cost)
    end

    # Verify a password against a bcrypt hash.
    # Requires the bcrypt gem to be installed.
    def self.verify(password, hash)
      Hashing.verify(password, hash)
    end

    # Perform zxcvbn-style strength estimation.
    # Returns a hash with :score, :patterns, and :crack_time_display.
    def self.zxcvbn(password)
      Zxcvbn.estimate(password)
    end
  end
end

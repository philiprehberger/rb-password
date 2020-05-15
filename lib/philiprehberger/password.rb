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
    def self.strength(password)
      Strength.compute(password)
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

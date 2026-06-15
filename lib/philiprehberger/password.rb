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

    # Compute strength of a single password.
    #
    # @param password [String] the password to evaluate
    # @return [Hash] strength hash with `:score` (0-4), `:label`, `:entropy`, and `:feedback`
    def self.strength(password)
      Strength.compute(password)
    end

    # Compute strength for a list of passwords in input order.
    # Each element is coerced via `to_s` so non-string entries don't raise.
    #
    # @param passwords [Enumerable<String>] passwords to grade
    # @return [Array<Hash>] strength hashes (one per input, same order)
    # @raise [ArgumentError] if `passwords` is not enumerable
    def self.batch_strength(passwords)
      raise ArgumentError, 'passwords must be enumerable' unless passwords.respond_to?(:each)

      passwords.map { |p| Strength.compute(p.to_s) }
    end

    # Estimated entropy of the password in bits (log2(pool_size ^ length)).
    # Pool size is inferred from the character classes present.
    #
    # @param password [String] the password to evaluate
    # @return [Float] estimated entropy in bits (0.0 for empty passwords)
    def self.entropy(password)
      Strength.entropy(password)
    end

    # Strength score as a 0-4 integer. Convenience accessor that returns
    # only the `:score` from {strength}.
    #
    # @param password [String] the password to evaluate
    # @return [Integer] strength score (0 = very weak, 4 = very strong)
    def self.score(password)
      Strength.compute(password)[:score]
    end

    # Predicate: is the password "strong enough"?
    #
    # Returns true when {score} is at least `threshold` (default 3, the
    # "strong" tier on the 0-4 scale: terrible/weak/fair/strong/excellent).
    # Use a higher `threshold` (e.g. 4) for stricter gating.
    #
    # @param password [String] the password to evaluate
    # @param threshold [Integer] minimum acceptable score (0-4)
    # @return [Boolean]
    def self.strong?(password, threshold: 3)
      score(password) >= threshold
    end

    # Generate a secure random password, passphrase, or PIN.
    #
    # @param length [Integer] password length (default 16; ignored for passphrase style)
    # @param uppercase [Boolean] include uppercase letters (default true)
    # @param lowercase [Boolean] include lowercase letters (default true)
    # @param digits [Boolean] include digits (default true)
    # @param symbols [Boolean] include symbols (default true)
    # @param style [Symbol, nil] `:passphrase` or `:pin` for alternative styles
    # @param words [Integer] word count for passphrase style (default 4)
    # @param separator [String] separator for passphrase style (default "-")
    # @return [String] the generated password
    def self.generate(**options)
      Generator.generate(**options)
    end

    # Detect keyboard patterns, sequences, and repeated characters.
    #
    # @param password [String] the password to inspect
    # @return [Array<Hash>] detected pattern hashes (keyboard rows, sequences, repeats)
    def self.keyboard_patterns(password)
      Patterns.detect(password)
    end

    # Hash a password using bcrypt.
    # Requires the bcrypt gem to be installed.
    #
    # @param password [String] the plaintext password to hash
    # @param cost [Integer] bcrypt cost factor (4-31, default 12)
    # @return [String] the bcrypt hash
    def self.hash(password, cost: 12)
      Hashing.hash(password, cost: cost)
    end

    # Verify a password against a bcrypt hash.
    # Requires the bcrypt gem to be installed.
    #
    # @param password [String] the plaintext password to verify
    # @param hash [String] the bcrypt hash to verify against
    # @return [Boolean] true when the password matches the hash
    def self.verify(password, hash)
      Hashing.verify(password, hash)
    end

    # Perform zxcvbn-style strength estimation.
    #
    # @param password [String] the password to evaluate
    # @return [Hash] zxcvbn-style report with `:score`, `:patterns`, and `:crack_time_display`
    def self.zxcvbn(password)
      Zxcvbn.estimate(password)
    end

    # Mask a password for safe display in logs, diagnostics, or UI surfaces.
    # Reveals the trailing `visible` characters and replaces the rest with
    # `mask` so that the full length of the password is still preserved.
    # When `visible` is 0 (default) the entire password is masked.
    #
    # @param password [String] the password to mask
    # @param visible [Integer] number of trailing characters to expose (>= 0)
    # @param mask [String] single-character replacement for masked positions
    # @return [String] the masked password
    # @raise [ArgumentError] if visible is negative or mask is not one character
    def self.mask(password, visible: 0, mask: '*')
      raise ArgumentError, 'visible must be >= 0' if visible.negative?
      raise ArgumentError, 'mask must be a single character' unless mask.is_a?(String) && mask.length == 1

      str = password.to_s
      return '' if str.empty?

      reveal = [visible, str.length].min
      masked_length = str.length - reveal
      (mask * masked_length) + str[-reveal, reveal].to_s
    end
  end
end

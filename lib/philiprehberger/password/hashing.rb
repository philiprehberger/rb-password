# frozen_string_literal: true

module Philiprehberger
  module Password
    module Hashing
      BCRYPT_ERROR_MESSAGE = <<~MSG.strip
        bcrypt gem is required for password hashing.
        Add it to your Gemfile: gem 'bcrypt', '~> 3.1'
        Or install directly: gem install bcrypt
      MSG

      DEFAULT_COST = 12

      # Hash a password using bcrypt.
      # Raises LoadError with a helpful message if bcrypt is not installed.
      #
      # @param password [String] the password to hash
      # @param cost [Integer] bcrypt cost factor (default: 12)
      # @return [String] the bcrypt hash string
      def self.hash(password, cost: DEFAULT_COST)
        require_bcrypt!
        BCrypt::Password.create(password.to_s, cost: cost)
      end

      # Verify a password against a bcrypt hash.
      # Raises LoadError with a helpful message if bcrypt is not installed.
      #
      # @param password [String] the password to verify
      # @param hash [String] the bcrypt hash to compare against
      # @return [Boolean] true if the password matches
      def self.verify(password, hash)
        require_bcrypt!
        BCrypt::Password.new(hash) == password.to_s
      end

      def self.require_bcrypt!
        require 'bcrypt'
      rescue LoadError
        raise LoadError, BCRYPT_ERROR_MESSAGE
      end

      private_class_method :require_bcrypt!
    end
  end
end

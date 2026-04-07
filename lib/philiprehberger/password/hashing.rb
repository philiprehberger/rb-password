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
      MIN_COST = 4
      MAX_COST = 31

      # Hash a password using bcrypt.
      # Raises LoadError with a helpful message if bcrypt is not installed.
      #
      # @param password [String] the password to hash (must be a non-empty String)
      # @param cost [Integer] bcrypt cost factor (default: 12, range: 4-31)
      # @return [String] the bcrypt hash string
      # @raise [ArgumentError] if password is not a non-empty String or cost is out of range
      def self.hash(password, cost: DEFAULT_COST)
        raise ArgumentError, 'password must be a String' unless password.is_a?(String)
        raise ArgumentError, 'password must not be empty' if password.empty?
        unless cost.is_a?(Integer) && cost.between?(MIN_COST, MAX_COST)
          raise ArgumentError, "cost must be an Integer between #{MIN_COST} and #{MAX_COST}"
        end

        require_bcrypt!
        BCrypt::Password.create(password, cost: cost)
      end

      # Verify a password against a bcrypt hash.
      # Returns false rather than raising on malformed hash strings.
      # Raises LoadError with a helpful message if bcrypt is not installed.
      #
      # @param password [String] the password to verify
      # @param hash [String] the bcrypt hash to compare against
      # @return [Boolean] true if the password matches
      def self.verify(password, hash)
        return false unless password.is_a?(String) && hash.is_a?(String)
        return false if password.empty? || hash.empty?

        require_bcrypt!
        BCrypt::Password.new(hash) == password
      rescue BCrypt::Errors::InvalidHash
        false
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

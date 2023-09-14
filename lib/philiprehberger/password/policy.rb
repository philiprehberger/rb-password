# frozen_string_literal: true

module Philiprehberger
  module Password
    class Policy
      Result = Struct.new(:valid?, :errors, :score, keyword_init: true)

      def initialize(min_length: 8, max_length: 128, require_uppercase: false, require_lowercase: false,
                     require_digit: false, require_symbol: false, reject_common: true, custom_passwords: [])
        @min_length = min_length
        @max_length = max_length
        @require_uppercase = require_uppercase
        @require_lowercase = require_lowercase
        @require_digit = require_digit
        @require_symbol = require_symbol
        @reject_common = reject_common
        @custom_passwords = Set.new(custom_passwords.map { |p| p.to_s.downcase }).freeze
      end

      # Validate a password against the policy.
      # Accepts an optional context hash for context-aware validation.
      #
      # @param password [String] the password to validate
      # @param context [Hash] optional context with :username, :email, :app_name keys
      # @return [Result] validation result with valid?, errors, and score
      def validate(password, context: {})
        errors = []

        return Result.new(valid?: false, errors: ['Password is required'], score: 0) if password.nil?

        pwd = password.to_s

        errors << "must be at least #{@min_length} characters" if pwd.length < @min_length
        errors << "must be at most #{@max_length} characters" if pwd.length > @max_length
        errors << 'must contain at least one uppercase letter' if @require_uppercase && !pwd.match?(/[A-Z]/)
        errors << 'must contain at least one lowercase letter' if @require_lowercase && !pwd.match?(/[a-z]/)
        errors << 'must contain at least one digit' if @require_digit && !pwd.match?(/\d/)
        errors << 'must contain at least one symbol' if @require_symbol && !pwd.match?(/[^a-zA-Z\d]/)
        errors << 'password is too common' if @reject_common && CommonPasswords.include?(pwd)
        if @custom_passwords.include?(pwd.downcase) && !errors.include?('password is too common')
          errors << 'password is too common'
        end

        # Context-aware validation
        errors.concat(validate_context(pwd, context)) unless context.nil? || context.empty?

        score = Strength.compute(pwd)[:score]

        Result.new(valid?: errors.empty?, errors: errors, score: score)
      end

      private

      def validate_context(password, context)
        errors = []
        pwd_lower = password.downcase

        if context[:username] && !context[:username].to_s.empty?
          username = context[:username].to_s.downcase
          errors << 'must not contain your username' if username.length >= 3 && pwd_lower.include?(username)
        end

        if context[:email] && !context[:email].to_s.empty?
          email = context[:email].to_s.downcase
          # Check full email
          errors << 'must not contain your email address' if pwd_lower.include?(email)

          # Check local part of email (before @)
          local_part = email.split('@').first
          if local_part && local_part.length >= 3 && pwd_lower.include?(local_part) && !errors.include?('must not contain your email address')
            errors << 'must not contain your email username'
          end
        end

        if context[:app_name] && !context[:app_name].to_s.empty?
          app_name = context[:app_name].to_s.downcase
          errors << 'must not contain the application name' if app_name.length >= 3 && pwd_lower.include?(app_name)
        end

        errors
      end
    end
  end
end

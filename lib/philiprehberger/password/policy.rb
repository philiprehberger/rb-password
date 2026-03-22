# frozen_string_literal: true

module Philiprehberger
  module Password
    class Policy
      Result = Struct.new(:valid?, :errors, keyword_init: true)

      DEFAULT_OPTIONS = {
        min_length: 8,
        max_length: 128,
        require_uppercase: false,
        require_lowercase: false,
        require_digit: false,
        require_symbol: false,
        reject_common: true
      }.freeze

      def initialize(**options)
        @options = DEFAULT_OPTIONS.merge(options)
      end

      def validate(password)
        errors = []

        if password.nil? || password.empty?
          return Result.new(valid?: false, errors: ['Password is required'])
        end

        if password.length < @options[:min_length]
          errors << "Must be at least #{@options[:min_length]} characters"
        end

        if password.length > @options[:max_length]
          errors << "Must be at most #{@options[:max_length]} characters"
        end

        if @options[:require_uppercase] && !password.match?(/[A-Z]/)
          errors << 'Must contain at least one uppercase letter'
        end

        if @options[:require_lowercase] && !password.match?(/[a-z]/)
          errors << 'Must contain at least one lowercase letter'
        end

        if @options[:require_digit] && !password.match?(/\d/)
          errors << 'Must contain at least one digit'
        end

        if @options[:require_symbol] && !password.match?(/[^a-zA-Z\d]/)
          errors << 'Must contain at least one special character'
        end

        if @options[:reject_common] && COMMON_PASSWORDS.include?(password.downcase)
          errors << 'Password is too common'
        end

        Result.new(valid?: errors.empty?, errors: errors)
      end
    end
  end
end

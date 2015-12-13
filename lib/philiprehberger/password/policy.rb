# frozen_string_literal: true

module Philiprehberger
  module Password
    class Policy
      Result = Struct.new(:valid?, :errors, :score, keyword_init: true)

      COMMON_PASSWORDS = %w[
        123456 password 12345678 qwerty 123456789 12345 1234 111111 1234567 dragon
        123123 baseball abc123 football monkey letmein shadow master 696969 mustang
        666666 qwertyuiop 123321 654321 superman qazwsx password1 password123 batman
        trustno1 iloveyou sunshine princess access admin flower hello charlie donald
        passw0rd whatever qwerty123 lovely 7777777 888888 123qwe welcome login
        starwars letmein123 monkey123 abc123456 admin123 master123 000000 1q2w3e4r
        112233 121212 555555 999999 1234567890 123abc zxcvbnm asdfghjkl qazwsxedc
        test test123 guest changeme root toor administrator passwd default secret
        love baby angel michael jordan shadow1 password2 jessica jennifer thomas
        soccer hockey ranger daniel george computer buster hunter tigger sunshine1
        thunder charlie1 robert taylor matrix arsenal liverpool chelsea manager
        killer harley davidson yamaha kawasaki samantha victoria elizabeth alexander
        benjamin jackson williams johnson martinez garcia rodriguez hernandez lopez
        gonzalez wilson anderson thomas taylor moore jackson martin lee harris clark
      ].uniq.freeze

      def initialize(min_length: 8, max_length: 128, require_uppercase: false, require_lowercase: false,
                     require_digit: false, require_symbol: false, reject_common: true)
        @min_length = min_length
        @max_length = max_length
        @require_uppercase = require_uppercase
        @require_lowercase = require_lowercase
        @require_digit = require_digit
        @require_symbol = require_symbol
        @reject_common = reject_common
      end

      def validate(password)
        errors = []

        return Result.new(valid?: false, errors: ['Password is required'], score: 0) if password.nil?

        pwd = password.to_s

        errors << "must be at least #{@min_length} characters" if pwd.length < @min_length
        errors << "must be at most #{@max_length} characters" if pwd.length > @max_length
        errors << 'must contain at least one uppercase letter' if @require_uppercase && !pwd.match?(/[A-Z]/)
        errors << 'must contain at least one lowercase letter' if @require_lowercase && !pwd.match?(/[a-z]/)
        errors << 'must contain at least one digit' if @require_digit && !pwd.match?(/\d/)
        errors << 'must contain at least one symbol' if @require_symbol && !pwd.match?(/[^a-zA-Z\d]/)
        errors << 'password is too common' if @reject_common && COMMON_PASSWORDS.include?(pwd.downcase)

        score = Strength.compute(pwd)[:score]

        Result.new(valid?: errors.empty?, errors: errors, score: score)
      end
    end
  end
end
